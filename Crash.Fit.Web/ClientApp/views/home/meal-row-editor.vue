﻿<template>
    <div class="modal fade" id="modal-default" style="display: block;" :class="{ in: show }">
        <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
            <button type="button" class="close" @click="cancel">
                <span aria-hidden="true">×</span></button>
            <h4 class="modal-title">{{ $t('addFood') }}</h4>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-sm-12">
                        <label>{{ $t('food') }}</label>
                        <food-picker :value="food" @change="val => foodSelected(val)" @createFood="name => createFood(name)" @createRecipe="name => createRecipe(name)" />
                    </div>
                </div>
                <div class="row" v-if="food">
                    <div class="col-sm-3">
                        <label>{{ $t('quantity') }}</label>
                        <input class="form-control" type="number" v-model="quantity" />
                    </div>
                    <div class="col-sm-9">
                        <label>{{ $t('portion') }}</label>
                        <select class="form-control" v-model="portion">
                            <option :value="undefined">g</option>
                            <option v-for="p in food.portions" :value="p">
                                {{ p.name }}
                            </option>
                        </select>
                    </div>
                </div>
                <div class="row" v-if="portion">
                    <div class="col-sm-12">
                        <label>{{ $t('weight') }}</label>
                        {{ weight }} g
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-default pull-left" @click="cancel">{{ $t('cancel')}}</button>
                <button class="btn btn-primary" @click="save" :disabled="!canSave">{{ $t('save')}}</button>
            </div>
        </div>
        </div>
    </div>
</template>

<script src="./meal-row-editor.js">
</script>

<style scoped>
    .row{ margin-bottom: 5px;}
</style>