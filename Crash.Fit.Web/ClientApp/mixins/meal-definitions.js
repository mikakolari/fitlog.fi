﻿import constants from '../store/constants'

export default {
    computed: {
        $mealDefinitions() {
            return this.$store.state.nutrition.mealDefinitions;
        }
    },
    created() {
        var self = this;
        var delay = 100;
        var loader = () => {
            if(self.isLoggedIn){
                self.$store.dispatch(constants.FETCH_MEAL_DEFINITIONS, {
                    success(mealDefinitions) {
                        if (self.$mealDefinitionsLoaded) {
                            self.$mealDefinitionsLoaded(mealDefinitions);
                        }
                    },
                    failure() { }
                });
            }
            else {
                setTimeout(() => {
                    delay = delay * 2;
                    loader();
                }, delay);
            }
        };

        loader();
    }
}