﻿export default {

    LOADING: 'LOADING',
    LOADING_DONE: 'LOADING_DONE',

    NEW_ID: 'uusi',
    RESTORE_ACTION: 'palauta',
    ROUTINE_PARAM: 'ohjelma',
    WORKOUT_PARAM: 'treeni',

    PROTEIN_ID: 8,
    FAT_ID: 52,
    CARB_ID: 77,
    ENERGY_ID: 34,
    ENERGY_DISTRIBUTION_ID: 36,
    PROTEIN_ENERGY_ID: 63,
    FAT_ENERGY_ID: 6,
    CARB_ENERGY_ID: 79,
    ENERGY_DIFFERENCE_ID: 64,

    WORKOUT_ENERGY_EXPENDITURE: 0.06,

    ACTIVITY_FACTOR_SLEEP: 0.9,
    ACTIVITY_FACTOR_INACTIVITY: 1.3,
    ACTIVITY_FACTOR_LIGHT_ACTIVITY: 1.8,
    ACTIVITY_FACTOR_MODERATE_ACTIVITY: 2.4,
    ACTIVITY_FACTOR_HEAVY_ACTIVITY: 4,

    // Profile / User
    STORE_TOKENS: 'STORE_TOKENS',
    REFRESH_TOKEN: 'REFRESH_TOKEN',
    FETCH_PROFILE: 'FETCH_PROFILE',
    FETCH_PROFILE_SUCCESS: 'FETCH_PROFILE_SUCCESS',
    SAVE_PROFILE: 'SAVE_PROFILE',
    SAVE_PROFILE_SUCCESS: 'SAVE_PROFILE_SUCCESS',
    LOGOUT: 'LOGOUT',
    LOGOUT_SUCCESS: 'LOGOUT_SUCCESS',
    UPDATE_LOGIN: 'UPDATE_LOGIN',

    // Meal diary
    SELECT_MEAL_DIARY_DATE: 'SELECT_MEAL_DIARY_DATE',
    SELECT_MEAL_DIARY_DATE_SUCCESS: 'SELECT_MEAL_DIARY_DATE_SUCCESS',
    SAVE_MEAL_DIARY_SETTINGS: 'SAVE_MEAL_DIARY_SETTINGS',
    SAVE_MEAL_DIARY_NUTRIENTS_SUCCESS: 'SAVE_MEAL_DIARY_NUTRIENTS_SUCCESS',

    // Meals
    FETCH_MEALS: 'FETCH_MEALS',
    FETCH_MEALS_SUCCESS: 'FETCH_MEALS_SUCCESS',
    FETCH_MEAL: 'FETCH_MEAL',
    FETCH_MEAL_SUCCESS: 'FETCH_MEAL_SUCCESS',
    SAVE_MEAL: 'SAVE_MEAL',
    SAVE_MEAL_DRAFT: 'SAVE_MEAL_DRAFT',
    DELETE_MEAL: 'DELETE_MEAL',
    SAVE_MEAL_SUCCESS: 'SAVE_MEAL_SUCCESS',
    DELETE_MEAL_SUCCESS: 'DELETE_MEAL_SUCCESS',
    RESTORE_MEAL: 'RESTORE_MEAL',
    RESTORE_MEAL_SUCCESS: 'RESTORE_MEAL_SUCCESS',
    SELECT_MEAL_DATE_RANGE: 'SELECT_MEAL_DATE_RANGE',
    SELECT_MEAL_DATE_RANGE_SUCCESS: 'SELECT_MEAL_DATE_RANGE_SUCCESS',
    SAVE_MEAL_ROW: 'SAVE_MEAL_ROW',
    SAVE_MEAL_ROW_SUCCESS: 'SAVE_MEAL_ROW_SUCCESS',
    DELETE_MEAL_ROW: 'DELETE_MEAL_ROW',
    DELETE_MEAL_ROW_SUCCESS: 'DELETE_MEAL_ROW_SUCCESS',
    SAVE_MEAL_ROW_DRAFT: 'SAVE_MEAL_ROW_DRAFT',

    // Foods
    FETCH_MY_FOODS: 'FETCH_MY_FOODS',
    FETCH_MY_FOODS_SUCCESS: 'FETCH_MY_FOODS_SUCCESS',
    FETCH_FOODS: 'FETCH_FOODS',
    FETCH_FOOD: 'FETCH_FOOD',
    SAVE_FOOD: 'SAVE_FOOD',
    DELETE_FOOD: 'DELETE_FOOD',
    FETCH_MOST_USED_FOODS: 'FETCH_MOST_USED_FOODS',
    FETCH_MOST_USED_FOODS_SUCCESS: 'FETCH_MOST_USED_FOODS_SUCCESS',
    FETCH_LATEST_FOODS: 'FETCH_LATEST_FOODS',
    FETCH_LATEST_FOODS_SUCCESS: 'FETCH_LATEST_FOODS_SUCCESS',

    // Recipes
    FETCH_RECIPES: 'FETCH_RECIPES',
    FETCH_RECIPE: 'FETCH_RECIPE',
    SAVE_RECIPE: 'SAVE_RECIPE',
    DELETE_RECIPE: 'DELETE_RECIPE',

    // Nutrients
    FETCH_NUTRIENTS: 'FETCH_NUTRIENTS',
    FETCH_NUTRIENTS_SUCCESS: 'FETCH_NUTRIENTS_SUCCESS',
    SAVE_NUTRIENT_SETTINGS: 'SAVE_NUTRIENT_SETTINGS',
    SAVE_NUTRIENT_SETTINGS_SUCCESS: 'SAVE_NUTRIENT_SETTINGS_SUCCESS',

    // Nutrition goals
    FETCH_NUTRITION_GOALS: 'FETCH_NUTRITION_GOALS',
    FETCH_NUTRITION_GOALS_SUCCESS: 'FETCH_NUTRITION_GOALS_SUCCESS',
    FETCH_NUTRITION_GOAL: 'FETCH_NUTRITION_GOAL',
    FETCH_NUTRITION_GOAL_SUCCESS: 'FETCH_NUTRITION_GOAL_SUCCESS',
    FETCH_ACTIVE_NUTRITION_GOAL: 'FETCH_ACTIVE_NUTRITION_GOAL',
    FETCH_ACTIVE_NUTRITION_GOAL_SUCCESS: 'FETCH_ACTIVE_NUTRITION_GOAL_SUCCESS',
    SAVE_NUTRITION_GOAL: 'SAVE_NUTRITION_GOAL',
    SAVE_NUTRITION_GOAL_SUCCESS: 'SAVE_NUTRITION_GOAL_SUCCESS',
    ACTIVATE_NUTRITION_GOAL: 'ACTIVATE_NUTRITION_GOAL',
    ACTIVATE_NUTRITION_GOAL_SUCCESS: 'ACTIVATE_NUTRITION_GOAL_SUCCESS',
    DELETE_NUTRITION_GOAL: 'DELETE_NUTRITION_GOAL',
    DELETE_NUTRITION_GOAL_SUCCESS: 'DELETE_NUTRITION_GOAL_SUCCESS',

    // Meal rhythm
    FETCH_MEAL_DEFINITIONS: 'FETCH_MEAL_DEFINITIONS',
    FETCH_MEAL_DEFINITIONS_SUCCESS: 'FETCH_MEAL_DEFINITIONS_SUCCESS',
    SAVE_MEAL_DEFINITIONS: 'SAVE_MEAL_DEFINITIONS',
    SAVE_MEAL_DEFINITIONS_SUCCESS: 'SAVE_MEAL_DEFINITIONS_SUCCESS',
    DELETE_MEAL_DEFINITION: 'DELETE_MEAL_DEFINITION',

    // MuscleGroups
    FETCH_MUSCLEGROUPS: 'FETCH_MUSCLEGROUPS',
    FETCH_MUSCLEGROUPS_SUCCESS: 'FETCH_MUSCLEGROUPS_SUCCESS',

    // Equipment
    FETCH_EQUIPMENT: 'FETCH_EQUIPMENT',
    FETCH_EQUIPMENT_SUCCESS: 'FETCH_EQUIPMENT_SUCCESS',

    // Workout diary
    SELECT_WORKOUT_DIARY_DATE: 'SELECT_WORKOUT_DIARY_DATE',
    SELECT_WORKOUT_DIARY_DATE_SUCCESS: 'SELECT_WORKOUT_DIARY_DATE_SUCCESS',
    //SAVE_WORKOUT_DIARY_SETTINGS: 'SAVE_WORKOUT_DIARY_SETTINGS',
    //SAVE_WORKOUT_DIARY_SETTINGS_SUCCESS: 'SAVE_WORKOUT_DIARY_SETTINGS_SUCCESS',

    // Workouts
    FETCH_WORKOUTS: 'FETCH_WORKOUTS',
    FETCH_WORKOUTS_SUCCESS: 'FETCH_WORKOUTS_SUCCESS',
    FETCH_WORKOUT: 'FETCH_WORKOUT',
    SAVE_WORKOUT: 'SAVE_WORKOUT',
    SAVE_WORKOUT_SUCCESS: 'SAVE_WORKOUT_SUCCESS',
    DELETE_WORKOUT: 'DELETE_WORKOUT',
    DELETE_WORKOUT_SUCCESS: 'DELETE_WORKOUT_SUCCESS',
    // Exercises
    FETCH_EXERCISES: 'FETCH_EXERCISES',
    FETCH_EXERCISES_SUCCESS: 'FETCH_EXERCISES_SUCCESS',
    FETCH_LATEST_EXERCISES: 'FETCH_LATEST_EXERCISES',
    FETCH_LATEST_EXERCISES_SUCCESS: 'FETCH_LATEST_EXERCISES_SUCCESS',
    FETCH_MOST_USED_EXERCISES: 'FETCH_MOST_USED_EXERCISES',
    FETCH_MOST_USED_EXERCISES_SUCCESS: 'FETCH_MOST_USED_EXERCISES_SUCCESS',
    FETCH_EXERCISE: 'FETCH_EXERCISE',
    SAVE_EXERCISE: 'SAVE_EXERCISE',
    SAVE_EXERCISE_SUCCESS: 'SAVE_EXERCISE_SUCCESS',
    DELETE_EXERCISE: 'DELETE_EXERCISE',
    DELETE_EXERCISE_SUCCESS: 'DELETE_EXERCISE_SUCCESS',
    SELECT_WORKOUT_DATE_RANGE: 'SELECT_WORKOUT_DATE_RANGE',
    SELECT_WORKOUT_DATE_RANGE_SUCCESS: 'SELECT_WORKOUT_DATE_RANGE_SUCCESS',
    SAVE_1RM: "SAVE_1RM",
    SAVE_1RM_SUCCESS: "SAVE_1RM_SUCCESS",

    // Routines
    FETCH_ROUTINES: 'FETCH_ROUTINES',
    FETCH_ROUTINES_SUCCESS: 'FETCH_ROUTINES_SUCCESS',
    FETCH_ROUTINE: 'FETCH_ROUTINE',
    FETCH_ACTIVE_ROUTINE: 'FETCH_ACTIVE_ROUTINE',
    FETCH_ACTIVE_ROUTINE_SUCCESS: 'FETCH_ACTIVE_ROUTINE_SUCCESS',
    SAVE_ROUTINE: 'SAVE_ROUTINE',
    SAVE_ROUTINE_SUCCESS: 'SAVE_ROUTINE_SUCCESS',
    DELETE_ROUTINE: 'DELETE_ROUTINE',
    DELETE_ROUTINE_SUCCESS: 'DELETE_ROUTINE_SUCCESS',
    ACTIVATE_ROUTINE: 'ACTIVATE_ROUTINE',
    ACTIVATE_ROUTINE_SUCCESS: 'ACTIVATE_ROUTINE_SUCCESS',
    FETCH_ROUTINE_WORKOUT: 'FETCH_ROUTINE_WORKOUT',

    // Training goals
    FETCH_TRAINING_GOALS: 'FETCH_TRAINING_GOALS',
    FETCH_TRAINING_GOALS_SUCCESS: 'FETCH_TRAINING_GOALS_SUCCESS',
    FETCH_TRAINING_GOAL: 'FETCH_TRAINING_GOAL',
    FETCH_TRAINING_GOAL_SUCCESS: 'FETCH_TRAINING_GOAL_SUCCESS',
    FETCH_ACTIVE_TRAINING_GOAL: 'FETCH_ACTIVE_TRAINING_GOAL',
    FETCH_ACTIVE_TRAINING_GOAL_SUCCESS: 'FETCH_ACTIVE_TRAINING_GOAL_SUCCESS',
    SAVE_TRAINING_GOAL: 'SAVE_TRAINING_GOAL',
    SAVE_TRAINING_GOAL_SUCCESS: 'SAVE_TRAINING_GOAL_SUCCESS',
    ACTIVATE_TRAINING_GOAL: 'ACTIVATE_TRAINING_GOAL',
    ACTIVATE_TRAINING_GOAL_SUCCESS: 'ACTIVATE_TRAINING_GOAL_SUCCESS',
    DELETE_TRAINING_GOAL: 'DELETE_TRAINING_GOAL',
    DELETE_TRAINING_GOAL_SUCCESS: 'DELETE_TRAINING_GOAL_SUCCESS',

    // Activities
    FETCH_ACTIVITIES: 'FETCH_ACTIVITIES',
    FETCH_ACTIVITIES_SUCCESS: 'FETCH_ACTIVITIES_SUCCESS',
    FETCH_ENERGY_EXPENDITURES: 'FETCH_ENERGY_EXPENDITURES',
    FETCH_ENERGY_EXPENDITURES_SUCCESS: 'FETCH_ENERGY_EXPENDITURES_SUCCESS',
    SELECT_ENERGY_EXPENDITURE_DATE_RANGE: 'SELECT_ENERGY_EXPENDITURE_DATE_RANGE',
    SELECT_ENERGY_EXPENDITURE_DATE_RANGE_SUCCESS: 'SELECT_ENERGY_EXPENDITURE_DATE_RANGE_SUCCESS',
    SAVE_ENERGY_EXPENDITURE: 'SAVE_ENERGY_EXPENDITURE',
    SAVE_ENERGY_EXPENDITURE_SUCCESS: 'SAVE_ENERGY_EXPENDITURE_SUCCESS',
    DELETE_ENERGY_EXPENDITURE: 'DELETE_ENERGY_EXPENDITURE',
    DELETE_ENERGY_EXPENDITURE_SUCCESS: 'DELETE_ENERGY_EXPENDITURE_SUCCESS',
    FETCH_ACTIVITY_PRESETS: 'FETCH_ACTIVITY_PRESETS',
    FETCH_ACTIVITY_PRESETS_SUCCESS: 'FETCH_ACTIVITY_PRESETS_SUCCESS',
    SAVE_ACTIVITY_PRESETS: 'SAVE_ACTIVITY_PRESETS',
    SAVE_ACTIVITY_PRESETS_SUCCESS: 'SAVE_ACTIVITY_PRESETS_SUCCESS',
    SAVE_ACTIVITY_PRESET_DAY: 'SAVE_ACTIVITY_PRESET_DAY',
    SAVE_ACTIVITY_PRESET_DAY_SUCCESS: 'SAVE_ACTIVITY_PRESET_DAY_SUCCESS',
    FETCH_ACTIVITY_PRESET_DAYS: 'FETCH_ACTIVITY_PRESET_DAYS',
    FETCH_ACTIVITY_PRESET_DAYS_SUCCESS: 'FETCH_ACTIVITY_PRESET_DAYS_SUCCESS',
    // Measurements

    // Feedback
    FETCH_BUGS: 'FETCH_BUGS',
    FETCH_BUGS_SUCCESS: 'FETCH_BUGS_SUCCESS',
    FETCH_IMPROVEMENTS: 'FETCH_IMPROVEMENTS',
    FETCH_IMPROVEMENTS_SUCCESS: 'FETCH_IMPROVEMENTS_SUCCESS',
    SAVE_FEEDBACK: 'SAVE_FEEDBACK',
    SAVE_FEEDBACK_SUCCESS: 'SAVE_FEEDBACK_SUCCESS',
    SAVE_VOTE: 'SAVE_VOTE',
    SAVE_VOTE_SUCCESS: 'SAVE_VOTE_SUCCESS',
    FETCH_VOTES: 'FETCH_VOTES',
    FETCH_VOTES_SUCCESS: 'FETCH_VOTES_SUCCESS',

    // Clipboard
    CLIPBOARD_COPY: ' CLIPBOARD_COPY',
    CLIPBOARD_COPY_SUCCESS: ' CLIPBOARD_COPY_SUCCESS',
    CLIPBOARD_CLEAR: 'CLIPBOARD_CLEAR',
    CLIPBOARD_CLEAR_SUCCESS: 'CLIPBOARD_CLEAR_SUCCESS',
    MEAL: 'MEAL',
    MEAL_ROWS: 'MEAL_ROWS',


    // Clear
    ACTIVITIES_CLEAR: 'ACTIVITIES_CLEAR',
    CLIPBOARD_CLEAR: 'CLIPBOARD_CLEAR',
    FEEDBACK_CLEAR: 'FEEDBACK_CLEAR',
    NUTRITION_CLEAR: 'NUTRITION_CLEAR',
    PROFILE_CLEAR: 'PROFILE_CLEAR',
    TRAINING_CLEAR: 'TRAINING_CLEAR'
}