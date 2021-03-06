﻿import constants from '../../store/constants'
import api from '../../api'
import toaster from '../../toaster'
export default {
    data() {
        return {
            id: null,
            name: null,
            percentageBW: null,
            targets: {}
        }
    },
    computed: {
        muscleGroups() {
            return this.$store.state.training.muscleGroups;
        }
    },
    methods: {
        save() {
            var self = this;

            var exercise = {
                id: self.id,
                name: self.name,
                percentageBW: self.percentageBW,
                targets: []
            };
            for (var i in self.targets) {
                if (self.targets[i]) {
                    exercise.targets.push(i);
                }
            }

            self.$store.dispatch(constants.SAVE_EXERCISE, {
                exercise,
                success() {
                    toaster.info(self.$t('saveSuccessful'));
                    self.$router.replace({ name: 'exercises' });
                },
                failure() {
                    toaster(self.$t('saveFailed'));
                }
            });
        },
        cancel() {
            this.$router.go(-1);
        },
        deleteExercise() {
            var self = this;
            self.$store.dispatch(constants.DELETE_EXERCISE, {
                exercise: { id: self.id },
                success() {
                    self.$router.push({ name: 'exercises' });
                },
                failure() {
                    toaster(self.$t('deleteFailed'));
                }
            });
        }
    },
    created() {
        var self = this;
        var id = this.$route.params.id;
        self.$store.dispatch(constants.FETCH_MUSCLEGROUPS, {
            success() {
                if (id == constants.NEW_ID) {
                    self.id = undefined;
                    self.name = undefined;
                    self.targets = {};
                    self.$store.commit(constants.LOADING_DONE);
                }
                else {
                    self.$store.dispatch(constants.FETCH_EXERCISE, {
                        id,
                        success(exercise) {
                            self.id = exercise.id;
                            self.name = exercise.name;
                            self.percentageBW = exercise.percentageBW;
                            self.targets = {};
                            exercise.targets.forEach(t => {
                                self.targets[t] = true;
                            });
                            self.$store.commit(constants.LOADING_DONE);
                        },
                        failure() {
                            toaster(self.$t('fetchFailed'));
                        }
                    });
                }
            },
            failure() {
                toaster(self.$t('fetchFailed'));
            }
        });
    }
}