<template>
  <li>
    <router-link
      :to="{ name: 'threads', params: { board: board.board } }"
      :data-nsfw="board.nsfw"
      v-html="board_text"
    />
  </li>
</template>

<script>
export default {
  props: {
    board: {
      type: Object,
      default: () => ({ title: 'Unknown' }),
    },
  },
  computed: {
    board_text() {
      return `${this.board.title} - ${this.board.description}`;
    },
  },
};
</script>
