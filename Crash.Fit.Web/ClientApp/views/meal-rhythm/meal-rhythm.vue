﻿<template>
    <div v-if="!loading">
        <section class="content-header"><h1>{{ $t("mealRhythm") }}</h1></section>
        <section class="content">
            <div class="row">
                <div class="col-sm-12">
                    <div class="row hidden-xs">
                        <div class="col-sm-6 col-text-30">{{ $t('mealName') }}</div>
                        <div class="col-sm-2 col-time">{{ $t('starts') }}</div>
                        <div class="col-sm-2 col-time">{{ $t('ends') }}</div>
                        <div class="col-sm-2 col-actions-3"></div>
                    </div>
                    <template v-for="(def, index) in definitions">
                        <div class="row">
                            <div class="col-sm-6 col-text-30">
                                <label class="hidden-sm hidden-md hidden-lg">{{ $t('mealName') }}</label>
                                <input class="form-control" v-model="def.name" />
                            </div>
                            <div class="col-xs-6 col-time">
                                <label class="hidden-sm hidden-md hidden-lg">{{ $t('starts') }}</label>
                                <datetime-picker :value="def.start" @change="val => def.start=val" :format="'HH:mm'"></datetime-picker>
                            </div>
                            <div class="col-xs-6 col-time">
                                <label class="hidden-sm hidden-md hidden-lg">{{ $t('ends') }}</label>
                                <datetime-picker :value="def.end" @change="val => def.end=val" :format="'HH:mm'"></datetime-picker>
                            </div>
                            <div class="col-xs-12 col-actions-1">
                                <label class="hidden-sm hidden-md hidden-lg">&nbsp;</label>
                                <button class="btn btn-sm btn-danger" @click="deleteMeal(index)">{{ $t('delete') }}</button>
                            </div>
                        </div>
                        <div class="row meal-row-separator hidden-sm hidden-md hidden-lg">
                                <div class="col-sm-12"><hr /></div>
                        </div>
                    </template>
                    
                    <div class="row table-actions">
                        <div class="col-sm-6"><button class="btn" @click="addMeal">{{ $t('add') }}</button></div>
                        <div class="col-sm-6"></div>
                    </div>
                    <br />
                    <div class="row">
                        <div class="col-sm-6 col-text-30">
                        <label class="hidden-sm hidden-md hidden-lg">{{ $t('otherTimes') }}</label>
                        <input class="form-control" v-model="othersName" /></div>
                        <div class="col-sm-4 hidden-xs">{{ $t('otherTimes') }}</div>
                    </div>
                    
                    
                </div>
            </div>
            <hr />
            <div class="row">
                <div class="col-sm-12">
                    <button class="btn btn-primary" @click="save">{{ $t('save')}}</button>
                </div>
            </div>
        </section>
    </div>
</template>

<script src="./meal-rhythm.js">
</script>

<style scoped>
    div.meal-row {
        margin-bottom: 5px;
    }
    div.meal-row-separator hr {
        border: 1px solid #00c0ef;
    }
</style>