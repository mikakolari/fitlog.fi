<template>
    <div v-if="!loading">
        <section class="content-header"><h1>{{ $t("workouts") }}</h1></section>
        <section class="content">
            <div class="row">
                <div class="col-sm-12">
                    <div class="btn-group">
                        <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                            {{ formatDate(start) }} - {{ formatDate(end) }} <span class="caret"></span>
                        </button>
                        <ul class="dropdown-menu">
                            <li class="clickable"><a @click="showWeek">{{ $t("currentWeek") }}</a></li>
                            <li class="clickable"><a @click="showMonth">{{ $t("currentMonth") }}</a></li>
                            <li role="separator" class="divider"></li>
                            <li class="clickable"><a @click="showDays(7)">7 {{ $t("days") }}</a></li>
                            <li class="clickable"><a @click="showDays(14)">14{{ $t("days") }}</a></li>
                            <li class="clickable"><a @click="showDays(30)">30{{ $t("days") }}</a></li>
                            <li role="separator" class="divider"></li>
                            <li class="custom-date"><span>{{ $t("timeInterval") }}</span></li>
                            <li class="custom-date">
                                <datetime-picker :value="start" :format="'DD.MM.YYYY'" @change="changeStart"></datetime-picker>
                                <datetime-picker :value="end" :format="'DD.MM.YYYY'" @change="changeEnd"></datetime-picker>
                            </li>
                        </ul>
                    </div>
                    <div class="btn-group" v-if="activeRoutine">
                        <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">{{ $t("log") }} <span class="caret"></span></button>
                        <ul class="dropdown-menu">
                            <li v-for="workout in activeRoutine.workouts">
                                <a @click="createWorkout(activeRoutine.id, workout.id)">{{ workout.name }}</a>
                            </li>
                            <li role="separator" class="divider"></li>
                            <li>
                                <a @click="createWorkout()">{{ $t("freeWorkout") }}</a>
                            </li>
                        </ul>
                    </div>
                    <button class="btn btn-primary" @click="createWorkout(undefined)" v-if="!activeRoutine">{{ $t("create") }}</button>
                    
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row">
                <div class="col-sm-12">
                    <div class="row">
                        <div class="col-xs-12">
                             <ul class="nav nav-tabs">
                                <li class="clickable" :class="{ active: tab === 'workouts' }"><a @click="tab = 'workouts'">{{ $t("workouts") }}</a></li>
                                <li class="clickable" :class="{ active: tab === 'goals' }"><a @click="tab = 'goals'">{{ $t("routineProgress") }}</a></li>
                            </ul>
                        </div>
                    </div>
                    <div v-if="tab === 'workouts'">
                        <div class="outer" v-if="workouts.length > 0">
                        <div class="inner">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th class="time freeze"><div><div>&nbsp;</div></div></th>
                                            <template v-for="muscleGroup in muscleGroups">
                                                <th class="muscle-group"><div><div>{{ muscleGroup.name}}</div></div></th>
                                            </template>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr class="workout" v-for="workout in workouts">
                                            <td class="freeze">
                                                <router-link :to="{ name: 'workout-details', params: { id: workout.id } }">{{ formatDateTime(workout.time) }}</router-link>
                                            </td>
                                            <template v-for="muscleGroup in muscleGroups">
                                                <td class="muscle-group">{{ workout.muscleGroupSets[muscleGroup.id] }}</td>
                                            </template>
                                            <td><button class="btn btn-danger btn-xs" @click="deleteWorkout(workout)">{{ $t("delete") }}</button></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="row" v-if="workouts.length == 0">
                            <div class="col-sm-12">
                                <br />
                                {{ $t("noWorkouts") }}
                            </div>
                        </div>
                    </div>
                    <div v-if="tab === 'goals'">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>{{ $t('exercise') }}</th>
                                    <th>{{ $t('reps') }}</th>
                                    <th>{{ $t('load') }}</th>
                                    <th>{{ $t('completed') }}</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="goal in progress" @click="goal.expanded=(!goal.expanded)">
                                    <td>{{ goal.exercise.name }}</td>
                                    <td>{{ goal.reps }}</td>
                                    <td>{{ goal.load }} %</td>
                                    <td>
                                        <div class="progress">
                                          <div class="progress-bar progress-bar-aqua" :style="'width: '+(goal.sets.length / goal.times * 100)+'%'">{{ goal.sets.length }} / {{ goal.times}}</div>
                                            <span v-if="goal.sets.length == 0">{{ goal.sets.length }} / {{ goal.times}}</span>
                                        </div>
                                        <span v-for="set in goal.sets" v-show="goal.expanded"><br />{{ set.reps }} x {{ set.load }}%</span>
                                    </td>
                                    <td>
                                        <i v-if="goal.expanded" class="fa fa-chevron-up"></i>
                                        <i v-else class="fa fa-chevron-down"></i>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </section>
    </div>
</template>

<script src="./workouts.js">
</script>

<style scoped>
    li.custom-date {
        padding: 3px 10px;
    }

        li.custom-date button {
            margin-top: 3px;
        }

    .outer {
        position: relative;
    }

    .inner {
        overflow-x: auto;
        overflow-y: visible;
        margin-left: 100px;
    }

    .table {
        width: auto;
        table-layout: fixed;
    }

    th.time {
        width: 120px;
        white-space: nowrap;
        border-width: 0px;
    }

        th.time > div {
            transform: translate(86px, 29px) rotate(-45deg);
        }

            th.time > div > div {
                border-bottom: 1px solid #ccc;
                padding: 5px 10px;
                width: 100px;
            }

    .freeze {
        position: absolute;
        margin-left: -120px;
        width: 120px;
        text-align: right;
    }

    th.time {
    }

    #workout-list td:nth-child(1) {
        border-right: 1px solid #ccc;
    }

    th.muscle-group {
        height: 100px;
        white-space: nowrap;
    }

        th.muscle-group > div {
            transform: translate(15px, 8px) rotate(-45deg);
            width: 20px;
        }

            th.muscle-group > div > div {
                border-bottom: 1px solid #ccc;
                padding: 5px 10px;
                width: 100px;
            }

    td.muscle-group {
        border-right: 1px solid #ccc;
        text-align: center;
    }

    td.freeze, td.muscle-group {
        padding-top: 12px;
    }
</style>