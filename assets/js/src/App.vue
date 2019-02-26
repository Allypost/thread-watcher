<template>
  <div id="app">
    <header>
      <h1>Thread Watcher</h1>
    </header>
    <main>
      <h1 v-if="$asyncComputed.boards.updating">
        Loading...
      </h1>
      <h1 v-else-if="$asyncComputed.boards.error">
        Something went wrong. Please try again later.
      </h1>
      <ul v-else-if="$asyncComputed.boards.success">
        <Board
          v-for="board in boards"
          :key="board.board"
          :board="board"
        />
      </ul>
    </main>
  </div>
</template>

<script>
import { mapState } from 'vuex';
import Board from './components/Board.vue';

export default {
  name: 'App',
  components: {
    Board,
  },
  asyncComputed: {
    api_config: {
      get() {
        return (
          fetch(this.api_url)
            .then(res => res.json())
        );
      },
      default: {},
    },

    boards_link() {
      return this.api_config.boards_link;
    },

    boards: {
      get() {
        if (!this.boards_link) {
          return null;
        }

        return (
          this.$http
            .get(this.boards_link)
            .then(res => res.json())
            .then(res => res.data)
        );
      },

      default: [],
    },
  },
  computed: {
    ...mapState({
      api_url: state => state.api_url,
    }),
  },
};
</script>

<style>
#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
}
main {
  margin-top: 60px;
}
</style>
