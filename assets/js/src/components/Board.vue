<template>
  <li>
    <a
      :href="board_url"
      :data-nsfw="board.nsfw"
    >{{ board.title }} - {{ board_description }}</a>
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
    board_url() {
      const { board } = this.board;

      return `/${board}/`;
    },

    board_description() {
      const textarea = document.createElement('textarea');
      textarea.innerHTML = this.board.description;
      return textarea.value;
    },
  },
};
</script>
