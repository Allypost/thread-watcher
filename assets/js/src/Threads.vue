<template>
  <div id="app">
    <header>
      <h1>Thread Watcher: {{ board_name }}</h1>
      <router-link :to="{ name: 'boards' }">
        &larr; Back
      </router-link>
    </header>
    <main>
      <h1 v-if="$asyncComputed.threads.updating">
        Loading...
      </h1>
      <h1 v-else-if="$asyncComputed.threads.error">
        Something went wrong. Please try again later.
      </h1>
      <ul v-else-if="$asyncComputed.threads.success">
        <Thread
          v-for="thread in threads"
          :key="thread.id"
          :thread="thread"
        />
      </ul>
    </main>
  </div>
</template>

<script>
import { mapState } from 'vuex';
import Thread from './components/Thread.vue';

export default {
  name: 'App',
  components: { Thread },
  asyncComputed: {
    threads: {
      get() {
        if (!this.threads_link) {
          return null;
        }

        return (
          this.$http
            .get(this.threads_link)
            .then(res => res.json())
            .then(res => res.data)
        );
      },

      default: [],
    },
  },
  computed: {
    ...mapState({
      api_urls: state => state.api_urls,
    }),

    board_name() {
      return this.$route.params.board;
    },

    threads_link() {
      if (!this.api_urls) {
        return null;
      }

      return this.api_urls.board_link.replace('%s', this.board_name);
    },
  },
};
</script>
