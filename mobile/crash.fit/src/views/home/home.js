import { openURL } from 'quasar'
import moment from 'moment'
import constants from '../../store/constants'
import { QIcon,QCard,QCardTitle,QCardMain,QCardActions,QCardSeparator,QModal,QBtn,QTabs,QTab,QTabPane,QScrollArea,QFab,QFabAction,QContextMenu, QItem,QDatetime, ActionSheet, QPullToRefresh } from 'quasar'
import EnergyDistributionBar from '../../components/energy-distribution-bar'
import NutrientBar from '../../components/nutrient-bar'
import MealRowEditor from '../../components/meal-row-editor'
import MealSettings from './meal-settings'
import utils from '../../utils'
import nutrientsMixin from '../../mixins/nutrients'
import mealDefinitionsMixin from '../../mixins/meal-definitions'
import nutritionGoalMixin from '../../mixins/nutrition-goal'
import NutrientKnob from '../../components/nutrient-knob'
import { Toast } from 'quasar'

export default {
  mixins: [nutrientsMixin, mealDefinitionsMixin, nutritionGoalMixin],
  components: {
    QIcon,QCard,QCardTitle,QCardMain,QCardActions,QCardSeparator, QModal,QBtn,QTabs,QTab,QTabPane,QScrollArea,QFab,QFabAction,QContextMenu, QItem, QDatetime,QPullToRefresh,
    EnergyDistributionBar,
    NutrientBar,
    MealRowEditor,
    MealSettings,
    NutrientKnob
  },
  data () {
    return {
      showFab: false,
      proteinId: constants.PROTEIN_ID,
      carbId: constants.CARB_ID,
      fatId: constants.FAT_ID,
      energyId: constants.ENERGY_ID,
      energyDistributionId: constants.ENERGY_DISTRIBUTION_ID,
      selectedRow: undefined,
      datepickerVisible: false
    }
  },
  computed: {
    selectedDate() {
      return this.$store.state.nutrition.diaryDate;
    },
    dateText() {
        if (moment().isSame(this.selectedDate, 'd')) {
            return this.$t('today');
        }
        else if (moment().subtract(1,'day').isSame(this.selectedDate, 'd')) {
            return this.$t('yesterday');
        }
        return this.formatDate(this.selectedDate);
    },
    visibleNutrients() {
          return this.$store.state.nutrition.nutrients.filter(n => n.homeOrder || n.homeOrder === 0).sort((n1,n2) => n1.homeOrder - n2.homeOrder);
      },
    meals() {
      var self = this;
      var start = moment(self.selectedDate).startOf('day');
      var end = moment(self.selectedDate).endOf('day');
      var defs = self.$store.state.nutrition.mealDefinitions;
      var meals = self.$store.state.nutrition.meals.filter(m => moment(m.time).isBetween(start, end));
      var result = defs.map(d => { return { definition: d, meal: meals.find(m => m.definitionId == d.id) } });
      meals.filter(m => !m.definitionId).forEach(m => {
          var index = result.findIndex(r => r.definition && r.definition.startHour && r.definition.startHour > m.time.getHours());
          if (index == -1) {
              result.push({ meal: m });
          }
          else
              result.splice(index, 0, { meal: m });
          }
      );
      return result;
    },
    workouts() {
        var self = this;
        return this.$store.state.training.workouts.filter(w => moment(w.time).isSame(self.selectedDate, 'day'));
    },
    nutritionGoal() {
        return this.$store.state.nutrition.activeNutritionGoal;
    },
    nutrients() {
      var result = {};
      this.meals.filter(m => m.meal).forEach(m => {
          for (var i in m.meal.nutrients) {
              if (!result[i]) {
                  result[i] = 0;
              }
              result[i] += m.meal.nutrients[i];
          }
      });
      return result;
    },
    nutrientGroups() {
        var nutrients = this.$store.state.nutrition.nutrients;
        return this.$store.state.nutrition.nutrientGroups.map(g => {
            return {
                name: g.name,
                nutrients: nutrients.filter(n => n.fineliGroup == g.id).sort((n1, n2) => n1.name < n2.name ? -1 : 1)
            }
        });
        return 
    },
    mealCopy() {
        if (this.$store.state.clipboard.type == constants.MEAL) {
            return this.$store.state.clipboard.data;
        }
        return undefined;
    },
    rowCopy() {
        if (this.$store.state.clipboard.type == constants.MEAL_ROWS) {
            return this.$store.state.clipboard.data;
        }
        return undefined;
    }
  },
  methods: {
    changeDate(date) {
        this.datepickerVisible = false;
        var newDate;
        if (date == 'today') {
            newDate = new Date();
        }
        else if (date == 'yesterday') {
            newDate = moment().subtract(1, 'days').toDate();
        }
        else if (date === -1) {
            newDate = moment(this.selectedDate).subtract(1, 'days').toDate();
        }
        else if (date === 1){
            newDate = moment(this.selectedDate).add(1, 'days').toDate();
        }
        else {
            newDate = date;
        }
        if (!moment(newDate).isSame(this.selectedDate, 'd')) {
            this.$store.dispatch(constants.SELECT_MEAL_DIARY_DATE, { date: newDate });
            this.fetchData();
        }
    },
    fetchData(refreshCallback) {
      var self = this;
      var start = moment(self.selectedDate).startOf('day');
      var end = moment(self.selectedDate).endOf('day');
      var force = refreshCallback && true;
      self.$store.dispatch(constants.FETCH_MEALS, {
        start,
        end,
        force,
        success: (meals) => {
          self.$store.commit(constants.LOADING_DONE);
          if(refreshCallback){
            refreshCallback();
          }
        },
        failure: () => { }
      });
      self.$store.dispatch(constants.FETCH_WORKOUTS, { start: start, end: end });
    },
    refresh(done){
        this.init(done);
    },
    swipe(event){
        if(event.direction == "left"){
            this.changeDate(1);
        }
        else if(event.direction == "right"){
            this.changeDate(-1);
        }
        else{
            return false;
        }
    },
    mealName(defMeal) {
      if (defMeal.definition) {
          return defMeal.definition.name;
      }
      return this.time(defMeal.meal.time);
    },
    addRow(mealdef){
      this.selectedRow = { 
        mealDefinitionId: mealdef.definition ? mealdef.definition.id : undefined,
        mealId: mealdef.meal ? mealdef.meal.id : undefined, 
        food: undefined, 
        quantity: undefined, 
        portion: undefined
      };
      this.$refs.editRow.open(this.selectedRow);
    },
    clickRow(mealDef, row){
      var self = this;
      ActionSheet.create({
        title: `${row.foodName} ${ row.quantity } ${ row.portionName || 'g' }`,
        gallery: true,
        actions: [
          {
            label: self.$t('edit'),
            icon: 'fa-edit',
            handler: function() {
              self.editRow(row);
            }
          },
          {
            label: self.$t('copy'),
            icon: 'fa-copy',
            handler: function() {
              self.copyRow(row);
            }
          },
          {
            label: self.$t('delete'),
            icon: 'fa-trash',
            handler: function() {
              self.deleteRow(mealDef, row);
            }
          }
        ]
      });
    },
    editRow(row){
      this.selectedRow = row;
      this.$refs.editRow.open(this.selectedRow);
    },
    copyMeal(meal) {
        this.$store.dispatch(constants.CLIPBOARD_COPY, {
            type: constants.MEAL,
            data: meal
        });
    },
    pasteMeal(mealDef) {
        var self = this;
        var meal = self.$store.state.clipboard.data;
        self.appendRows(mealDef, meal.rows);
    },
    copyRow(row) {
        this.$store.dispatch(constants.CLIPBOARD_COPY, {
            type: constants.MEAL_ROWS,
            data: [row]
        });
    },
    pasteRows(mealDef) {
        var self = this;
        var rows = self.$store.state.clipboard.data;
        self.appendRows(mealDef, rows);
    },
    appendRows(mealDef, rows) {
        var self = this;
        var meal = {
            id: mealDef.meal ? mealDef.meal.id : undefined,
            date: self.selectedDate,
            definitionId: mealDef.definition.id,
            rows : mealDef.meal && mealDef.meal.rows ? mealDef.meal.rows.map(r => { return { foodId: r.foodId, quantity: r.quantity, portionId: r.portionId }}) : []
        }
        rows.forEach(r => {
            meal.rows.push({ foodId: r.foodId, quantity: utils.parseFloat(r.quantity), portionId: r.portionId });
        });
        self.$store.dispatch(constants.SAVE_MEAL, {
            meal,
            success() { },
            failure() { }
        });
    },
    deleteRow(mealdef, row){
      this.$store.dispatch(constants.DELETE_MEAL_ROW, {
          row,
          success() { 
            if(mealdef.meal.rows.length == 0){
              mealdef.meal = undefined;
            }
          },
          failure() { }
      });
      return true;
    },
    saveRow(row){
      row.date = this.selectedDate;
      this.$store.dispatch(constants.SAVE_MEAL_ROW, {
          row,
          success() {},
          failure() { }
      });
      this.selectedRow = {};
      this.$refs.editRow.close();
    },
    showMealSettings(){
      this.$refs.mealSettings.open();
    },
    nutrientGoal(nutrientId, meal) {
      return utils.nutrientGoal(this.$nutritionGoal, this.workouts, nutrientId, this.selectedDate, meal);
    },
    init(done){
        var self = this;
        if(self.isLoggedIn){
            self.$store.dispatch(constants.FETCH_MEAL_DEFINITIONS, {
                success() {
                    self.fetchData(done);
                },
                failure() {
                    Toast.create(self.$t('fetchFailed'));
                    self.$store.commit(constants.LOADING_DONE);
                 }
            });
            /*
            self.$store.dispatch(constants.FETCH_NUTRIENTS, {
                force: true,
                success() { },
                failure() { }
            });
            */
            self.$store.dispatch(constants.FETCH_LATEST_FOODS, {
                success() { },
                failure() { }
            });
            self.$store.dispatch(constants.FETCH_MOST_USED_FOODS, {
                success() { },
                failure() { }
            });
            self.$store.dispatch(constants.FETCH_MY_FOODS, {
                success() { },
                failure() { }
            });
        }
        else {
            setTimeout(() => {
                self.init();
            } , 100);
        }
        
    
        
    }
  },
  created(){
    this.init();
    
  }
}
