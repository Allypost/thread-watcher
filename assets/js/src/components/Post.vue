<template>
  <div
    :id="post_id"
    class="post"
  >
    <div
      v-if="post_text"
      v-html="post_text"
    />
    <div v-if="post.file">
      <video
        v-if="post.file.meta.is_video"
        :src="post.file.meta.full_src"
      />
      <img
        v-else
        :src="post.file.meta.full_src"
        :alt="post.file.filename"
      >
    </div>
  </div>
</template>

<style lang="scss">
    .post {
        border: 3px solid black;
        margin: .5em 0;
    }
</style>

<script>
export default {
  props: {
    post: {
      type: Object,
      default: () => ({ body: { title: 'Unknown' } }),
    },
  },
  computed: {
    post_text() {
      const { body } = this.post;
      const { title, content } = body;

      return title || content;
    },

    post_id() {
      return `p${this.post.id}`;
    },
  },
};
</script>
