import Vue from 'vue';
import AsyncComputed from 'vue-async-computed';
import VueResource from 'vue-resource';
import App from './src/App.vue';
import store from './src/store';

Vue.config.productionTip = false;
Vue.use(AsyncComputed);
Vue.use(VueResource);

// eslint-disable-next-line no-new
new Vue({
  store,
  el: '#app',
  components: { App },
  template: '<app/>',
});
