<template>
  <div :class="{desktop: isDesktop }">
    <div class="row pad">
    </div>

    <q-scroll-area style="height: 90vh;">
        <div class="row pad">
            <q-datetime v-model="time" type="datetime" :format="$t('datetimeFormat')" :monday-first="true" :no-clear="true" :ok-label="$t('ok')" :cancel-label="$t('cancel')" :day-names="localDayNamesAbbr" :month-names="localMonthNames" :float-label="$t('time')" format24h />
        </div>
        <div class="row pad" v-for="(set,index) in sets" :key="index">
            <div class="col-6">
                <div v-if="exercises.length > 20">
                    <q-input color="amber" v-model="set.exerciseName" :float-label="$t('exercise')" >
                        <q-autocomplete @search="searchExercise" :min-characters="1" @selected="(exercise) => exerciseSelected(set,exercise)" />
                    </q-input>
                </div>
                <div v-else>
                    <q-select v-model="set.exerciseName" :options="exercises" :float-label="$t('exercise')" @change="(exercise) => exerciseSelected(set,exercise)" />
                </div>
            </div> 
             <div class="col-2">
                <q-input v-model="set.reps" type="number" :float-label="$t('reps')" />
            </div>
            <div class="col-2">
                <q-input v-model="set.weights" type="number" :float-label="$t('weights')" />
            </div>
            <div class="col-2">
                <q-fab small flat color="primary" icon="more_vert" active-icon="more_horiz" direction="left">
                    <q-fab-action color="negative" @click="deleteSet(index)" icon="delete"></q-fab-action>
                    <q-fab-action color="secondary" @click="copySet(index)" icon="content_copy"></q-fab-action>
                </q-fab>
            </div>
        </div>
        <div class="row pad buttons">
            <q-btn round glossy color="primary" icon="fa-plus" small @click="addSet"></q-btn>
        </div>

        <div class="row pad buttons">
            <q-btn @click="cancel">{{ $t('cancel') }}</q-btn>
            <q-btn color="primary" @click="save">{{ $t('save') }}</q-btn>
        </div>
    </q-scroll-area>
    
  </div>
</template>

<script src="./workout-details.js">
</script>

<style lang="stylus" scoped>
.q-tab-pane { height: 60vh;}
.scroll { height: 100%;}
.desktop .q-tab-pane { height: 70vh;}
.desktop .q-scrollarea { height: 100%;}
</style>
