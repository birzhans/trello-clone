<template>
   <draggable :list="lists" group="lists" class="board dragArea" @end="listMoved">
    <List v-for="list in original_lists" :key="list.id" :list="list" />

    <a v-if="!editing" @click="toggleEditing" class="btn btn-secondary m-2">Add a List</a>
		<div class="m-1 list" v-if="editing">
			<input type="text" ref="message" placeholder="type..." v-model="message" class="form-control mb-1">
			<button @click="createList" class="btn btn-secondary">Save</button>
      <a v-if="editing" @click="toggleEditing" class="btn m-2">Cancel</a>
		</div>
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
      lists: this.original_lists,
      editing: false,
      message: ""
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
    toggleEditing() {
      this.editing = !this.editing
    },

    createList() {
      var data = new FormData
      data.append('list[name', this.message)

      Rails.ajax({
        url: 'lists',
        type: 'POST',
        data: data,
        dataType: 'json',
        success: (data) => {
          window.store.lists.push(data)
          this.message = ""
          this.editing = false
        }
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
