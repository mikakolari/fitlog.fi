import constants from '../../store/constants'
import toaster from '../../toaster'

export default {
    data () {
        return {
            goals: []
        }
    },
    computed: {
  
    },
    components: {},
    methods: {
        createGoal(){
            this.$router.push({ name: 'nutrition-goal-details', params: { id: constants.NEW_ID } });
        },
        activate(goal){
            var self = this;
            this.$store.dispatch(constants.ACTIVATE_NUTRITION_GOAL, {
                goal,
                success() { },
                failure() {
                    toaster(this.$t('activationFailed'));
                }
            });
        },
        deleteGoal(goal) {
            var self = this;
            this.$store.dispatch(constants.DELETE_NUTRITION_GOAL, {
                goal,
                success() { },
                failure() {
                    toaster(this.$t('deleteFailed'));
                }
            });
        }
    },
    created() {
        var self = this;
       
        self.$store.dispatch(constants.FETCH_NUTRITION_GOALS, {
            success(goals) {
                self.goals = goals;
                self.$store.commit(constants.LOADING_DONE);
            },
            failure() { }
        });
    }
}