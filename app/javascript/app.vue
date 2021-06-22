<template>
   <draggable :list="lists" group="lists" class="board dragArea" @end="listMoved">
    <div v-for="list in original_lists" :key="list.id" class="list m-2">
      <h4 class="m-2">{{ list.name }}</h4>

      <draggable v-model="list.cards" group="cards" class="dragArea" @change="cardMoved">
        <div v-for="card in list.cards" :key="card.id" class="card card-body m-1">
          {{ card.name }}
        </div>
      </draggable>

      <div class="m-1">
        <input type="text" placeholder="type..." v-model="messages[list.id]" class="form-control mb-1">
      <button @click="submitMessages(list.id)" class="btn btn-secondary">Save</button>
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
      var data = new FormData
      data.append('list[position]', event.newIndex + 1)
      
      Rails.ajax({
        url: `lists/${this.lists[event.newIndex].id}/move`,
        type: 'PATCH',
        data: data,
        dataType: 'json'
      })
    },

    cardMoved(event) {
      const evt = event.added || event.moved
      if (evt == undefined) return

      const element = evt.element

      const list_index = this.lists.findIndex((list) => {
        return list.cards.find((card) => {
          return card.id === element.id
        })
      })

      var data = new FormData
      data.append('card[list_id]', this.lists[list_index].id)
      data.append('card[position]', evt.newIndex + 1)

      Rails.ajax({
        url: `cards/${element.id}/move`,
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

.board {
  white-space: nowrap;
  overflow-x: auto;

}

.list {
  background: #e2e4e6;
  border-radius: 3px;
  width: 270px;
  display: inline-block;
  vertical-align: top;
  margin-right: 10px;
  padding: 10px;
}
</style>
