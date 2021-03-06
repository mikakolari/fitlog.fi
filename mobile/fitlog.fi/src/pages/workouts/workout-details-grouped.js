import constants from '../../store/constants'
import utils from '../../utils'
import ExercisesMixin from '../../mixins/exercises'
import PageMixin from '../../mixins/page'
import Help from './workout-help'
import ExercisePicker from '../../components/exercise-picker'

export default {
    mixins:[ExercisesMixin, PageMixin],
    components: {
        'workout-help': Help,
        'exercise-picker':ExercisePicker
    },
  data () {
    return {
        id: null,
        time: undefined,
        duration: undefined,
        groups:[],
        exercises: [],
        energyExpenditure: undefined,
        energySpecified: false,
        selectedGroup: undefined
    }
  },
    computed: {
        canSave(){
            return this.time && this.groups.length > 0 && this.groups.find(g => g.exercise);
        },
        totalMinutes() {
            var time = this.duration ? new Date(this.duration) : undefined;
            if (time) {
                return time.getHours() * 60 + time.getMinutes();
            }
            return null;
        },
        weight() {
            if (this.$profile) {
                return this.$profile.weight;
            }
            return null;
        },
        energyExpenditureEstimate() {
            if (this.totalMinutes && this.weight) {
                return constants.WORKOUT_ENERGY_EXPENDITURE * this.totalMinutes * this.weight;
            }
            return null;
        }
    },
    watch: {
        energyExpenditureEstimate() {
            if (!this.energySpecified || !this.energyExpenditure ) {
                this.energyExpenditure = this.formatDecimal(this.energyExpenditureEstimate);
            }
        }
    },
  methods: {
    addGroup(){
        var group = {
            exercise: undefined,
            sets: [],
            collapsed: false
        }
        this.groups.push(group);
        this.addSet(group);
        this.selectExercise(group);
    },
    copyGroup(group){
        this.groups.push({...group});
    },
    deleteGroup(index){
        this.groups.splice(index, 1);
    },
    addSet(group) {
        var set = { 
            reps: undefined,
            weights: undefined
        };
        group.sets.push(set);
    },
    
    deleteSet(group, index){
        group.sets.splice(index, 1);
    },
    copySet(group, set){
        group.sets.push({...set});
    },

    searchExercise(text, done){
        var self = this;
        done(self.exercises.filter(e => e.name.indexOf(text) >= 0));
    },
    /*
    exerciseSelected(group,exercise){
        if(exercise.id){
            group.exercise = exercise;
            group.exerciseId = exercise.id;
            group.exerciseName = exercise.name;
        }
        else {
            group.exerciseName = exercise;
        }
    },
    */
    save() {
        var self = this;
        var time = self.duration ? new Date(self.duration) : undefined;
        var workout = {
            id: self.id,
            time: self.time,
            hours: time ? time.getHours() : undefined,
            minutes: time ? time.getMinutes() : undefined,
            sets: [],
            energyExpenditure: self.energySpecified ? self.energyExpenditure : undefined
        };
        self.groups.forEach(g => {
            g.sets.forEach(s => {
                workout.sets.push({ exerciseId: g.exercise ? g.exercise.id : g.exerciseId, exerciseName: g.exercise ? g.exercise.name : g.exerciseName, reps: utils.parseFloat(s.reps), weights: utils.parseFloat(s.weights) })
            });
        });
        self.$store.dispatch(constants.SAVE_WORKOUT, {
            workout
        }).then(savedWorkout => {
            self.id = savedWorkout.id;
            self.notifySuccess(self.$t('saveSuccessful'));
        }).catch(_ => {
            self.notifyError(self.$t('saveFailed'));
        });
    },
    cancel() {
        this.$router.go(-1);
    },
    deleteWorkout() {
        var self = this;
        self.$store.dispatch(constants.DELETE_WORKOUT, {
            recipe: { id: self.id }
        }).then(_ => {
            self.$router.push({ name: 'workouts' });
        }).catch(_ => {
            self.notifyError(self.$t('deleteFailed'));
        });
    },

    populate(workout) {
        var self = this;
        self.id = workout.id;
        self.time = workout.time;
        self.duration = '01.01.2000 ' + (workout.hours || 0) + ':' + (workout.minutes || 0);
        self.groups = [];
        self.$store.dispatch(constants.FETCH_EXERCISES, { }).then(exercises => {
            self.exercises = exercises.map(e => {return {...e, label: e.name, value: e }});
            self.groups = [];
            if(workout.sets){

                var previousGroup = undefined;
                var previousExerciseId = undefined;

                workout.sets.forEach(s => {
                    var group;
                    var exercise = self.exercises.find(e => e.id == s.exerciseId);

                    if(s.exerciseId == previousExerciseId){
                        group = previousGroup;
                    }
                    else {
                        group = {
                            exercise: exercise,
                            sets: [],
                            collapsed: true
                        };
                        self.groups.push(group);
                    }
                    if(workout.id){
                        group.sets.push({ reps: s.reps, weights: s.weights});
                    }
                    else {
                        var weights = (s.load || s.load == 0) && exercise.oneRepMax ? s.load / 100 * exercise.oneRepMax : undefined;
                        if (weights) {
                            weights = utils.roundToNearest(weights, 2.5);
                        }
                        group.sets.push({ reps: s.reps, weights: weights});
                    }
                    previousGroup = group;
                    previousExerciseId = s.exerciseId;

                });
            }
            else {
                self.addGroup();
            }
            self.$store.commit(constants.LOADING_DONE);
        }).catch(_ => {
            self.notifyError(self.$t('fetchFailed'));
        });
 
    },
    selectExercise(group){
        this.selectedGroup = group;
        this.$refs.exercisePicker.show(this.selectedGroup);
    },
    exerciseSelected(exercise){
        this.selectedGroup.exercise = exercise;
        this.$refs.exercisePicker.hide();
    },
    showHelp(){
        this.$refs.help.open();
    }
},
  created () {
    var self = this;
    var id = self.$route.params.id;
    var routineId = self.$route.query[constants.ROUTINE_PARAM];
    var routineWorkoutId = self.$route.query[constants.WORKOUT_PARAM];

    if (id == constants.NEW_ID) {
        var workout = {
            id: undefined, 
            time: utils.previousHalfHour(),
            hours: 1,
            minutes: 0,
            sets: []
        };
        if(routineId && routineWorkoutId){
            self.$store.dispatch(constants.FETCH_ROUTINE, {
                id: routineId
            }).then(routine => {
                var routineWorkout = routine.workouts.find(w => w.id === routineWorkoutId);
                routineWorkout.exercises.forEach(e => {
                    var loadFrom = e.loadFrom || e.loadFrom == 0 ? e.loadFrom : e.loadTo;
                    var loadTo = e.loadTo || e.loadTo == 0 ? e.loadTo : e.loadFrom;
                    var step = (loadFrom || loadFrom == 0) && (loadTo || loadTo == 0) ? (loadTo - loadFrom) / (e.sets - 1) : undefined;
                    for (var i = 0; i < e.sets; i++){
                        workout.sets.push({ exerciseId: e.exerciseId, reps: e.reps, load: (step || step == 0) ? loadFrom + i * step : undefined });
                    }
                });
                self.populate(workout);
            }).catch(_ => {
                self.notifyError(self.$t('fetchFailed'));
            });
        }
        else {
            self.populate(workout);
            self.addGroup();
        }  
    }
    else {
        self.$store.dispatch(constants.FETCH_WORKOUT, {
            id
        }).then(workout => {
            self.populate(workout);
        }).catch(_ => {
            self.notifyError(self.$t('fetchFailed'));
        });
    }
  },
  beforeDestroy () {

  }
}
