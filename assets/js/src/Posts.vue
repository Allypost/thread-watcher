<template>
  <div id="app">
    <header>
      <h1>Thread Watcher: {{ board_name }}/{{ thread_full_name }}</h1>
      <router-link :to="{ name: 'threads', params: { board: board_name } }">
        &larr; Back
      </router-link>
    </header>
    <main>
      <h1 v-if="$asyncComputed.posts.updating">
        Loading...
      </h1>
      <h1 v-else-if="$asyncComputed.posts.error">
        Something went wrong. Please try again later.
      </h1>
      <Post
        v-for="post in posts"
        v-else-if="$asyncComputed.posts.success"
        :key="post.id"
        :post="post"
      />
    </main>
  </div>
</template>

<script>
import { mapState } from 'vuex';
import Post from './components/Post.vue';

export default {
  name: 'App',
  components: { Post },
  asyncComputed: {
    posts: {
      get() {
        if (!this.posts_link) {
          return null;
        }

        return (
          this.$http
            .get(this.posts_link)
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

    thread_name() {
      return this.$route.params.thread;
    },

    thread_full_name() {
      const threadName = this.thread_name;
      const firstPost = this.posts[0];

      if (!firstPost) {
        return threadName;
      }

      const { body } = firstPost;
      const { title, content } = body;

      return title || content || threadName;
    },

    posts_link() {
      if (!this.api_urls) {
        return null;
      }

      return (
        this
          .api_urls
          .thread_link
          .replace('%s', this.board_name)
          .replace('%d', this.thread_name)
      );
    },
  },
};
</script>
