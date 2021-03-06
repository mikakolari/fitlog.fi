import constants from '../../store/constants'
import PageMixin from '../../mixins/page'

export default {
  mixins: [PageMixin],
    data () {
        return {
          id: undefined,
          type: undefined,
          title: '',
          description: ''
        }
    },
    computed:{
      canSave(){
        return this.title && this.description;
      }
    },
    methods: {
      save() {
        var self = this;
        var feedback = {
            id: self.id,
            type: self.type,
            title: self.title,
            description: self.description
        };
        self.$store.dispatch(constants.SAVE_FEEDBACK, {
            feedback
        }).then(_ => {
          self.notifySuccess(self.$t('saveSuccessful'));
              if(feedback.type === 'Bug'){
                self.$router.replace({ name: 'bugs' });
              }
              else if(feedback.type === 'Improvement'){
                self.$router.replace({ name: 'improvements' });
              }
        }).catch(_ => {
          self.notifyError(self.$t('saveFailed'));
        });
      },
      cancel() {
        this.$router.go(-1);
      },
      deleteFeedback(){}
    },
    created () {
        this.type = this.$route.meta.type;
        this.$store.commit(constants.LOADING_DONE);
    },
    watch: {
      $route(){
        this.type = this.$route.meta.type;
        this.$store.commit(constants.LOADING_DONE);
      }
    }
}