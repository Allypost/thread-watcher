import Vue from 'vue';
import VueRouter from 'vue-router';
import AsyncComputed from 'vue-async-computed';
import VueResource from 'vue-resource';
import Boards from './src/Boards.vue';
import Threads from './src/Threads.vue';
import Posts from './src/Posts.vue';
import NotFound from './src/NotFound.vue';
import store from './src/store';

Vue.config.productionTip = false;
Vue.use(AsyncComputed);
Vue.use(VueResource);
Vue.use(VueRouter);

const routes = [
  { path: '/', name: 'boards', component: Boards },
  { path: '/:board/', name: 'threads', component: Threads },
  { path: '/:board/thread/:thread(\\d+)', name: 'posts', component: Posts },
  { path: '/*', component: NotFound },
];

const router = new VueRouter({
  mode: 'history',
  routes,
});

// eslint-disable-next-line no-new
new Vue({
  store,
  router,
}).$mount('#app');
