// === DEFAULT / CUSTOM STYLE ===
// WARNING! always comment out ONE of the two require() calls below.
// 1. use next line to activate CUSTOM STYLE (./src/themes)
// require(`./themes/app.${__THEME}.styl`)
// 2. or, use next line to activate DEFAULT QUASAR STYLE
require(`quasar/dist/quasar.${__THEME}.css`)
// ==============================

// Uncomment the following lines if you need IE11/Edge support
// require(`quasar/dist/quasar.ie`)
// require(`quasar/dist/quasar.ie.${__THEME}.css`)
require('./assets/common.css')
import Vue from 'vue'
import Quasar from 'quasar'
import { TouchHold, TouchSwipe } from 'quasar'

import router from './router'
import store from './store/store'
import VueI18n from 'vue-i18n'
import translations from './translations'
import moment from 'moment'

Vue.config.productionTip = false
Vue.use(Quasar) // Install Quasar Framework
Vue.use(VueI18n)
const i18n = new VueI18n({
  locale: 'fi',
  messages: translations
})
Vue.mixin({
    directives: {
        TouchHold,
        TouchSwipe
    },
    data () {
        return {
            cardTitleBackground: 'bg-grey-3'
        }
    },
  computed:{
      isLoggedIn(){
          return this.$store.state.profile.profile && true;
      },
      isDesktop(){
        return !this.$q.platform.is.cordova;
      },
      localMonthNames(){
        var tran = translations.fi;
        return [
          tran.january,
          tran.february,
          tran.march,
          tran.april,
          tran.may,
          tran.june,
          tran.july,
          tran.august,
          tran.september,
          tran.october,
          tran.november,
          tran.december]
      },
      localDayNames(){
        var tran = translations.fi;
        return [
          tran.sunday,
          tran.monday,
          tran.tuesday,
          tran.wednesday,
          tran.thursday,
          tran.friday,
          tran.saturday
        ]
      },
      localDayNamesAbbr(){
        var tran = translations.fi;
        return [
          tran.sundayAbbr,
          tran.mondayAbbr,
          tran.tuesdayAbbr,
          tran.wednesdayAbbr,
          tran.thursdayAbbr,
          tran.fridayAbbr,
          tran.saturdayAbbr
        ]
      }
  },
    methods: {
       formatDate(value) {
        if(!value){
            return '-';
        }
        var m = new moment(value);
        return m.format('DD.MM.YYYY');
    },
      formatTime(value) {
        if(!value){
            return '-';
        }
        var m = new moment(value);
        return m.format('HH:mm');
    },
    formatDateTime(value, format) {
        if(!value){
            return '-';
        }
        var m = new moment(value);
        format = format || 'DD.MM.YYYY HH:mm';
        return m.format(format);
    },
    formatUnit(unit){
        switch(unit){
            case 'G':
                return 'g';
            case 'MG':
                return 'mg';
            case 'UG':
                return '\u03BCg';
            case'KCAL':
                return 'kcal';
            case 'KJ':
                return 'kJ';
            default:
                return unit;
        }
    },
    formatDecimal (value, precision) {
        if (!value) {
            return value;
        }
        return value.toFixed(precision);
    }
  }
});

if (__THEME === 'mat') {
  require('quasar-extras/roboto-font')
}
import 'quasar-extras/material-icons'
// import 'quasar-extras/ionicons'
import 'quasar-extras/fontawesome'
// import 'quasar-extras/animate'

Quasar.start(() => {
  /* eslint-disable no-new */
  new Vue({
    el: '#q-app',
    router,
    store,
    i18n,
    render: h => h(require('./App'))
  })
})
