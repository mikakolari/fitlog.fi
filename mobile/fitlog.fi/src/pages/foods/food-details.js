import constants from '../../store/constants'
import utils from '../../utils'
import Help from './food-help'
import api from '../../api'
import PageMixin from '../../mixins/page'

var defaultNutrientPortion = { id: undefined, name: '100g', value: undefined, label: '100g' };

export default {
    mixins: [PageMixin],
    components: {
        'food-help': Help
    },
    data() {
        return {
            id: null,
            name: null,
            manufacturer: null,
            ean: null,
            nutrients: {},
            portions: [],
            tab: 'tab-1',
            selectedGroup: undefined,
            nutrientPortion: defaultNutrientPortion
        }
    },
    computed: {
        nutrientGroups() {
            return this.$store.state.nutrition.nutrientGroups;
        },
        nutrientsGrouped() {
            return this.$store.state.nutrition.nutrientsGrouped;
        },
        nutrientPortions() {
            var portions = [];
            portions.push({...defaultNutrientPortion, value: defaultNutrientPortion});
            if (this.portions.length === 0) {
                var portion = { name: this.$t('portion'), label:this.$t('portion'), nutrientPortion: true, weight: 100 }
                portions.push({...portion, value: portion});
            }
            else {
                this.portions.forEach(p => { portions.push({label: p.name, value: p}); });
            }
            return portions;
        },
        errors() {
            var errors = [];
            if (!this.name) {
                errors.push('Nimi puuttuu');
            }
            this.portions.forEach(p => {
                if (!p.name) {
                    errors.push('Annoksen nimi puuttuu');
                }
                else if (!p.weight || p.weight == '') {
                    errors.push('Annoksen "' + p.name + '" paino puuttuu');
                }
            });
            return errors;
        },
        isValid() {
            return this.errors.length === 0;
        },
        canSave(){
            return this.name && true;
        }
    },
    methods: {
        toggleGroup(group) {
            if (this.selectedGroup == group) {
                this.selectedGroup = undefined;
            }
            else {
                this.selectedGroup = group;
            }
        },
        changeNutrientPortion() {
            if (this.nutrientPortion.nutrientPortion && this.portions.length === 0) {
                this.portions.push(this.nutrientPortion);
            }
        },
        addPortion() {
            this.portions.push({ name: null, weight: null });
        },
        removePortion(index) {
            if (this.nutrientPortion == this.portions[index]) {
                this.nutrientPortion = defaultNutrientPortion;
            }
            this.portions.splice(index, 1);
        },
        weight(quantity, portion) {
            if (!quantity) {
                return '';
            }
            if (typeof (quantity) !== 'number') {
                quantity = parseFloat(quantity.replace(',', '.'));
            }

            if (portion) {
                return quantity * portion.weight;
            }
            return quantity;
        },
        save() {
            var self = this;
            var food = {
                id: self.id,
                name: self.name,
                manufacturer: self.manufacturer,
                ean: self.ean,
                nutrients: [],
                portions: self.portions ? self.portions.map(p => { return { id: p.id, name: p.name, weight: utils.parseFloat(p.weight), nutrientPortion: p === self.nutrientPortion } }) : []
            };
            for (var i in self.nutrients) {
                if (self.nutrients[i] || self.nutrients[i] == 0) {
                    food.nutrients.push({ nutrientId: i, amount: utils.parseFloat(self.nutrients[i]) });
                }
            }

            self.$store.dispatch(constants.SAVE_FOOD, {
                food
            }).then(_ => {
                self.$router.replace({ name: 'foods' });
            }).catch(_ => {
                self.notifyError(self.$t('saveFailed'));
            });
        },
        cancel() {
            this.$router.go(-1);
        },
        deleteFood() {
            var self = this;
            self.$store.dispatch(constants.DELETE_FOOD, {
                food: { id: self.id }
            }).then(_ => {
                self.$router.push({ name: 'foods' });
            }).catch(_ => {
                self.notifyError(self.$t('deleteFailed'));
            });
        },
        populate(food) {
            var self = this;
            self.id = food.id;
            self.name = food.name;
            self.manufacturer = food.manufacturer;
            self.ean = food.ean;
            self.portions = food.portions || [];
            if (food.nutrientPortionId) {
                self.nutrientPortion = self.portions.find(p => p.id === food.nutrientPortionId);
            }
            self.$store.dispatch(constants.FETCH_NUTRIENTS, { }).then(_ => {
                for (var i in self.nutrientsGrouped) {
                    var group = self.nutrientsGrouped[i];
                    for (var j in group) {
                        var nutrient = group[j];
                        var value = food.nutrients ? food.nutrients.find(n => n.nutrientId == nutrient.id) : undefined;
                        if (value) {
                            if (self.nutrientPortion && self.nutrientPortion != defaultNutrientPortion) {
                                self.nutrients[nutrient.id] = value.portionAmount;
                            }
                            else {
                                self.nutrients[nutrient.id] = value.amount;
                            }
                        }
                        else {
                            self.nutrients[nutrient.id] = undefined;
                        }
                    }
                }
                self.selectedGroup = self.nutrientGroups[0];
                self.$store.commit(constants.LOADING_DONE);
            }).catch(_ => {
                self.notifyError(self.$t('fetchFailed'));
            });
        },
        showHelp(){
            this.$refs.help.open();
        },
        readBarcode(){
            var self = this;
            try {    
                cordova.plugins.barcodeScanner.scan(
                    result => {
                        if(!result.canceled){
                            self.ean = result.text;
                            self.loadInfoByEan();
                        }
                    },
                    error => {
                        self.notifyError(error);
                    }
                );
            }
            catch(err){
                self.notifyError(err.message);
            }
        },
        loadInfoByEan() {
            var self = this;
            api.searchExternalFood(this.ean).then(response => {
                var food = response.data;
                if(!self.name){
                    self.name = food.name;
                }
                if(!self.manufacturer){
                    self.manufacturer = food.manufacturer;
                }
                food.nutrients.forEach(n => {
                    if(!self.nutrients[n.nutrientId]){
                        self.nutrients[n.nutrientId] = n.amount;
                    }
                });
                self.notifySuccess(self.$t('informationUpdated'));
            }).fail(xhr => {
                self.notifyError(self.$t('fetchFailed'));
            });
        }
    },
    created() {
        var self = this;
        var id = self.$route.params.id;
        if (id == constants.NEW_ID) {
            self.populate({ id: undefined, name: undefined, nutrients: [] });
        }
        else {
            self.$store.dispatch(constants.FETCH_FOOD, {
                id
            }).then(_ => {
                self.populate(food);
            }).catch(_ => {
                self.notifyError(self.$t('fetchFailed'));
            });
        }

    },
    mounted(){
        if(!this.name){
            this.$refs.nameInput.focus();
        }
    }
}
