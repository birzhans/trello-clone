<template>
   <draggable :list="lists" group="lists" class="board dragArea" @end="listMoved">
    <List v-for="list in original_lists" :key="list.id" :list="list" />
  </draggable>
</template>

<script>
import draggable from 'vuedraggable'
import List from './components/list'

export default {
  components: { draggable, List },
  props: ['original_lists'],
  data() {
    return {
      messages: { 0: 'wefew' },
      lists: this.original_lists
    }
  },

  methods: {
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

.board {
  white-space: nowrap;
  overflow-x: auto;

}
</style>
