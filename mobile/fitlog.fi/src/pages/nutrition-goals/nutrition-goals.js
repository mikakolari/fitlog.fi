import constants from '../../store/constants'
import PageMixin from '../../mixins/page'

export default {
    mixins: [PageMixin],
    data () {
        return {
            goals: []
        }
    },
    computed: {
  
    },
    components: {},
    methods: {
        showGoal(goal){
            this.$router.push({ name: 'nutrition-goal-details', params: { id: goal.id } });
        },
        createGoal(){
            this.$router.push({ name: 'nutrition-goal-details', params: { id: constants.NEW_ID } });
        },
        activate(goal){
            var self = this;
            this.$store.dispatch(constants.ACTIVATE_NUTRITION_GOAL, {
                goal
            }).then(_ => {
                self.notifySuccess(self.$t('saveSuccessful'));
            }).catch(_ => {
                self.notifyError(self.$t('saveFailed'));
            });
        },
        deleteGoal(goal) {
            var self = this;
            this.$store.dispatch(constants.DELETE_NUTRITION_GOAL, {
                goal
            }).catch(_ => {
                self.notifyError(this.$t('deleteFailed'));
            });
        },
        clickGoal(goal){
            var self = this;
            this.$q.actionSheet({
              title: goal.name,
              grid: true,
              actions: [
                {
                  label: self.$t('edit'),
                  icon: 'fas fa-edit',
                  handler: () => {
                    self.showGoal(goal);
                  }
                },
                {
                    label: self.$t('activate'),
                    icon: 'fas fa-check',
                    handler: () => {
                      self.activate(goal);
                    }
                },
                {
                  label: self.$t('delete'),
                  icon: 'fas fa-trash',
                  handler: () => {
                    self.deleteGoal(goal);
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
    },
    created() {
        var self = this;
       
        self.$store.dispatch(constants.FETCH_NUTRITION_GOALS, { }).then(goals => {
            self.goals = goals;
            self.$store.commit(constants.LOADING_DONE, { });
        });
    }
}