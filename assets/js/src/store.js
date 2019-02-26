import Vue from 'vue';
import Vuex, { Store } from 'vuex';

const getConfig = () => {
  const { ThreadWatcher = {} } = window;
  const { config = {} } = ThreadWatcher;

  return config;
};

const getApiUrl = () => {
  const config = getConfig();
  const { api_url: apiUrl = '/api' } = config;

  return apiUrl;
};

Vue.use(Vuex);
export default new Store({
  state: {
    config: getConfig(),
    api_url: getApiUrl(),
  },
});
