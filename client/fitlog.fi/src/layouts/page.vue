<template>
  <q-layout view="lHh Lpr lFf" :container="isDesktop" :class="{'boxed': isDesktop }" :style="layoutStyle">
    <q-layout-header :reveal="true">
      <q-toolbar color="tertiary" glossy>
        <q-btn flat dense round @click="menuOpen = !menuOpen">
          <q-icon name="menu" />
        </q-btn>
        <q-toolbar-title>
          <slot name="title"></slot>
        </q-toolbar-title>
        <div class="page-toolbar">
          <slot name="toolbar"></slot>
        </div>
      </q-toolbar>
    </q-layout-header>
    
    <q-layout-footer :value="true" :reveal="true" reveal-offset="50">
      <slot name="footer"></slot>
    </q-layout-footer>
    
     
    <q-layout-drawer v-model="menuOpen" content-class="bg-grey-2">
      <q-list no-border link inset-delimiter v-if="!isLoggedIn">
        <q-item :to="{ name: 'login' }">  
          <q-item-side icon="fas fa-sign-in-alt" />
          <q-item-main :label="$t('login')" />
        </q-item>
      </q-list>

      <q-list no-border link inset-delimiter v-if="isLoggedIn">
         <q-item :to="{ name: 'home' }" exact>  
          <q-item-side icon="fas fa-utensils" />
          <q-item-main :label="$t('diary')" />
        </q-item>
        <q-item :to="{ name: 'activity-levels' }" exact>  
          <q-item-side icon="fas fa-tachometer-alt" />
          <q-item-main :label="$t('activityLevels')" />
        </q-item>
        <q-list-header>{{ $t('nutrition') }}</q-list-header>
       
        <q-item :to="{ name: 'foods' }">  
          <q-item-side icon="kitchen" />
          <q-item-main :label="$t('foods')" />
        </q-item>
        <q-item :to="{ name: 'meal-rhythm' }">  
          <q-item-side icon="fas fa-clock" />
          <q-item-main :label="$t('mealRhythm')" />
        </q-item>
        <q-item :to="{ name: 'recipes' }">  
          <q-item-side icon="fas fa-book" />
          <q-item-main :label="$t('recipes')" />
        </q-item>
        <q-item :to="{ name: 'nutrition-goals' }">  
          <q-item-side icon="fas fa-crosshairs" />
          <q-item-main :label="$t('nutritionGoals')" />
        </q-item>
        <q-item :to="{ name: 'meals' }">  
          <q-item-side icon="fas fa-utensils" />
          <q-item-main :label="$t('meals')" />
        </q-item>
        <q-item :to="{ name: 'nutrition-chart' }">  
          <q-item-side icon="fas fa-chart-line" />
          <q-item-main :label="$t('nutritionChart')" />
        </q-item>
        <q-item :to="{ name: 'food-comparison' }">  
          <q-item-side icon="fas fa-balance-scale" />
          <q-item-main :label="$t('foodComparison')" />
        </q-item>
        <q-list-header>{{ $t('training') }}</q-list-header>
        <q-item :to="{ name: 'workouts' }">  
          <q-item-side icon="fas fa-heartbeat" />
          <q-item-main :label="$t('workouts')" />
        </q-item>
        <q-item :to="{ name: 'exercises' }">  
          <q-item-side icon="fitness_center" />
          <q-item-main :label="$t('exercises')" />
        </q-item>
        <q-item :to="{ name: 'routines' }">  
          <q-item-side icon="fas fa-calendar" />
          <q-item-main :label="$t('routines')" />
        </q-item>
        <q-item :to="{ name: 'rep-calculator' }">  
          <q-item-side icon="fas fa-calculator" />
          <q-item-main :label="$t('repCalculator')" />
        </q-item>
        <q-item :to="{ name: 'energy-expenditures' }">  
          <q-item-side icon="fas fa-fire" />
          <q-item-main :label="$t('energyExpenditures')" />
        </q-item>
        <q-list-header>{{ $t('measurements') }}</q-list-header>
        <q-item item :to="{ name: 'measurements' }">  
          <q-item-side icon="fas fa-weight" />
          <q-item-main :label="$t('measurements')" />
        </q-item>

        <q-list-header>{{ $t('profile') }}</q-list-header>
        <q-item :to="{ name: 'profile' }">  
          <q-item-side icon="fas fa-user" />
          <q-item-main :label="$t('profile')" />
        </q-item>
        <q-item @click.native="logout">
          <q-item-side icon="fas fa-sign-out-alt" />
          <q-item-main :label="$t('logout')" />
        </q-item>

        <q-list-header>{{ $t('getInvolved') }}</q-list-header>
        <q-item :to="{ name: 'improvements' }">  
          <q-item-side icon="fas fa-lightbulb" />
          <q-item-main :label="$t('improvements')" />
        </q-item>
        <q-item :to="{ name: 'bugs' }">  
          <q-item-side icon="fas fa-bug" />
          <q-item-main :label="$t('bugs')" />
        </q-item>
      </q-list>
      

    </q-layout-drawer>
    <slot name="foo"></slot>
    <q-page-container>
      <slot v-show="!loading" />
      <q-inner-loading :visible="loading">
        <q-spinner-dots size="100" />
      </q-inner-loading>
    </q-page-container>
    <q-window-resize-observable @resize="resize" :debounce="100" />
  </q-layout>
</template>

<script>

import constants from '../store/constants'
import storage from '../storage'

export default {
  name: 'LayoutPage',
  data () {
    return {
      menuOpen: false,
      layoutStyle: {}
    }
  },
  computed: {
    profile(){
      return this.$store.state.profile.profile;
    },
    token(){
      var token = storage.getItem('refresh_token');
      return token;
    },
    loading() {
          return this.$store.state.loading;
    }
  },
  methods: {
    logout(){
      this.$store.dispatch(constants.LOGOUT, { }).then(_ => {
        this.$router.replace({name: 'login'});
      });
    },
    resize(){
      if(this.isDesktop){
        var height = window.innerHeight;
        var width = window.innerWidth;
        this.layoutStyle = {
          height: height + 'px',
          width: (width > 1200 ? 1200 : width) + 'px'
        };
      } 
      else { 
        this.layoutStyle = {};
      }
    }
  },
  mounted(){
    this.resize();
  }
}
</script>

<style>
.boxed {
  min-width: 300px; 
  min-height: 500px; 
  margin: auto;
}
</style>
