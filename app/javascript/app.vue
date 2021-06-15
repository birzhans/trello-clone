<template>
   <draggable :list="lists" group="lists" class="row dragArea" @end="listMoved">
    <div v-for="(list, index) in original_lists" :key="list.id" class="col-3">
      <h4>{{ list.name }}</h4><hr>

      <div v-for="card in list.cards" :key="card.id" class="card card-body m-1">
        {{ card.name }}
      </div>

      <div class="card card-body">
        <textarea v-model="messages[list.id]" class="form-control"></textarea>
        <button @click="submitMessages(list.id)" class="btn btn-secondary mt-2">Save</button>
      </div>
    </div>
  </draggable>
</template>

<script>
import draggable from 'vuedraggable'

export default {
  components: { draggable },
  props: ['original_lists'],
  data() {
    return {
      messages: { 0: 'wefew' },
      lists: this.original_lists
    }
  },

  methods: {
    submitMessages(list_id) {
      console.log(this.messages[list_id]);

      var data = new FormData
      data.append('card[list_id]', list_id)
      data.append('card[name', this.messages[list_id])
      data.append('card[position]', 10)

      Rails.ajax({
        url: 'cards',
        type: 'POST',
        data: data,
        dataType: 'json',
        success: (data) => {
          const index = this.lists.findIndex(item => item.id == list_id)
          this.lists[index].cards.push(data)
          this.messages[list_id] = undefined
        }
      })
    },

    listMoved(event) {
      console.log(event);
      var data = new FormData
      data.append('list[position]', event.newIndex + 1)
      
      Rails.ajax({
        url: `lists/${this.lists[event.newIndex].id}/move`,
        type: 'PATCH',
        data: data,
        dataType: 'json'
      })
    }
  },
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}

.dragArea {
  min-height: 20px;
}
</style>
