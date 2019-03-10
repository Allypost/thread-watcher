<template>
  <li>
    <router-link
      :to="{ name: 'posts', params: { board: thread.board, thread: thread.id } }"
      v-html="thread_text"
    />
  </li>
</template>

<script>
export default {
  props: {
    thread: {
      type: Object,
      default: () => ({ body: { title: 'Unknown' } }),
    },
  },
  computed: {
    thread_text() {
      const { body } = this.thread;
      const { title, content } = body;

      return title || content || 'No title';
    },
  },
};
</script>
