<template>
	<div class="list m-2">
		<h4 class="m-2">{{ list.name }}</h4>

		<draggable v-model="list.cards" group="cards" class="dragArea" @change="cardMoved">
			<div v-for="card in list.cards" :key="card.id" class="card card-body m-1">
				{{ card.name }}
			</div>
		</draggable>

		<a @click="toggleEditing" class="btn btn-secondary m-2">{{ editingMessage }}</a>
		<div class="m-1" v-if="editing">
			<input type="text" ref="message" placeholder="type..." v-model="message" class="form-control mb-1">
			<button @click="createList" class="btn btn-secondary">Save</button>
		</div>
	</div>
</template>

<script>
import draggable from 'vuedraggable'

export default {
	components: { draggable },
	props: ["list"],

	data() {
		return {
			editing: false,
			message: '',
			editingMessage: 'Add a card'
		}
	},

	methods: {
		toggleEditing() {
			this.editing = !this.editing

			if (this.editing) {
				this.editingMessage = "Cancel"
				this.$nextTick(() => { this.$refs.message.focus() })
			} else {
				this.editingMessage = "Add a card"
			}
		},

		createList() {
      var data = new FormData
      data.append('card[list_id]', this.list.id)
      data.append('card[name', this.message)

      Rails.ajax({
        url: 'cards',
        type: 'POST',
        data: data,
        dataType: 'json',
        success: (data) => {
          const index = window.store.lists.findIndex(item => item.id == this.list.id)
          window.store.lists[index].cards.push(data)
          this.message = ""
					this.$nextTick(() => { this.$refs.message.focus() })
        }
      })
    },

		 cardMoved(event) {
      const evt = event.added || event.moved
      if (evt == undefined) return

      const element = evt.element

      const list_index = window.store.lists.findIndex((list) => {
        return list.cards.find((card) => {
          return card.id === element.id
        })
      })

      var data = new FormData
      data.append('card[list_id]', window.store.lists[list_index].id)
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