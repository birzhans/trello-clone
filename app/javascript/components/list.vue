<template>
	<div class="list m-2">
		<h4 class="m-2">{{ list.name }}</h4>

		<draggable v-model="list.cards" group="cards" class="dragArea" @change="cardMoved">
			<Card v-for="card in list.cards" :key="card.id" :card="card" :list="list" />
		</draggable>

		<a v-if="!editing" @click="toggleEditing" class="btn btn-secondary m-2">Add card</a>
		<div class="m-1" v-if="editing">
			<input type="text" ref="message" placeholder="type..." v-model="message" class="form-control mb-1">
			<button @click="createCard" class="btn btn-secondary">Save</button>
			<a v-if="editing" @click="toggleEditing" class="btn 4m-2">Cancel</a>
		</div>
	</div>
</template>

<script>
import draggable from 'vuedraggable'
import Card from './Card'

export default {
	components: { draggable, Card },
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

		createCard() {
      var data = new FormData
      data.append('card[list_id]', this.list.id)
      data.append('card[name', this.message)

      Rails.ajax({
        url: 'cards',
        type: 'POST',
        data: data,
        dataType: 'json',
        success: (data) => {
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
</style>