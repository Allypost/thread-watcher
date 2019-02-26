import Vue from 'vue';
import App from './src/App.vue';

Vue.config.productionTip = false;

// eslint-disable-next-line no-new
new Vue({
  el: '#app',
  components: { App },
  template: '<app/>',
});
