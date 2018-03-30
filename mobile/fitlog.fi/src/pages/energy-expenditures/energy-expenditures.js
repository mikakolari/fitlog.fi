import constants from '../../store/constants'
import api from '../../api'
import moment from 'moment'
import utils from '../../utils'
import EnergyExpenditureDetails from './energy-expenditure-details.vue'

export default {
    components:{
        EnergyExpenditureDetails
    },
    data () {
        return {
        }
    },
    computed: {
        energyExpenditures() {
            var self = this;
            return this.$store.state.training.energyExpenditures.filter(e => moment(e.time).isBetween(self.start, self.end));
        },
        start() {
            var self = this;
            return this.$store.state.training.energyExpendituresDisplayStart;
        },
        end() {
            var self = this;
            return this.$store.state.training.energyExpendituresDisplayEnd;
        }
    },
    methods: {
        showDays(days) {
            var end = moment().endOf('day').toDate();
            var start = moment().subtract(days - 1, 'days').startOf('day').toDate();
            this.showDateRange(start, end);
        },
        showDateRange(start, end) {
            var self = this;
            self.progress = [];
            self.$store.dispatch(constants.SELECT_ENERGY_EXPENDITURE_DATE_RANGE, {
                start: start,
                end: end,
                success() {
                    self.fetchEnergyExpenditures();
                }
            });
        },
        fetchEnergyExpenditures() {
            var self = this;
            this.$store.dispatch(constants.FETCH_ENERGY_EXPENDITURES, {
                start: self.start,
                end: self.end,
                success() {
                    self.$store.commit(constants.LOADING_DONE);
                }
            });
        },
        changeStart(date) {
            this.showDateRange(date, this.end);
        },
        changeEnd(date) {
            this.showDateRange(this.start, date);
        },
        createEnergyExpenditure() {
            var expenditure = { time: utils.previousHalfHour(), hours: 1, minutes: 0 };
            this.$refs.editEnergyExpenditureDetails.show(expenditure);
        },
        editEnergyExpenditure(expenditure) {
            this.$refs.editEnergyExpenditureDetails.show(expenditure);
        },
        saveEnergyExpenditure(energyExpenditure) {
            var self = this;
            self.$store.dispatch(constants.SAVE_ENERGY_EXPENDITURE, {
                energyExpenditure,
                success() {
                    self.notifySuccess(self.$t('saveSuccessful'));
                    self.$refs.editEnergyExpenditureDetails.hide();
                },
                failure() {
                    self.notifyError(self.$t('saveFailed'));
                }
            });
        },
        deleteEnergyExpenditure(energyExpenditure){
            var self = this;
            self.$store.dispatch(constants.DELETE_ENERGY_EXPENDITURE, {
                energyExpenditure,
                success() {
                    self.notifySuccess(self.$t('deleteSuccessful'));
                },
                failure() {
                    self.notifyError(self.$t('deleteFailed'));
                }
            })
        },
        clickEnergyExpenditure(expenditure){
            var self = this;
            if(expenditure.workoutId){
                self.$router.push({ name: 'workout-details', params: { id: expenditure.workoutId } });
            }
            else {
                this.$q.actionSheet({
                title: self.formatDateTime(expenditure.time),
                grid: true,
                actions: [
                    {
                    label: self.$t('edit'),
                    icon: 'fa-edit',
                    handler: () => {
                        self.editEnergyExpenditure(expenditure);
                    }
                    },
                    {
                    label: self.$t('delete'),
                    icon: 'fa-trash',
                    handler: () => {
                        self.deleteEnergyExpenditure(expenditure);
                    }
                    }
                ],
                dismiss: {
                    label: self.$t('cancel'),
                    handler: () => {
                        
                    }
                }
                });
            }
        }
    },
    created() {
        var self = this;
        self.$store.dispatch(constants.FETCH_ACTIVITIES, {
            start: self.start,
            end: self.end,
            success() {
                self.$store.commit(constants.LOADING_DONE);
            }
        });
        if (self.start && self.end) {
            self.fetchEnergyExpenditures();
        }
        else {
            self.showDays(7);
        }
    },
    beforeRouteUpdate (to, from, next) {
        next();
    }
}