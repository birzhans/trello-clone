<template>
  <div id="app" class="row">
    <div v-for="list in original_lists" :key="list.id" class="col-3">
      <h4>{{ list.name }}</h4><hr>

      <div v-for="card in list.cards" :key="card.id" class="card card-body m-2">
        {{ card.name }}
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['original_lists'],
  data: function () {
    return {
      message: "Hello Vue!"
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
