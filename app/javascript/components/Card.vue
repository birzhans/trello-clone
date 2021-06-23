<template>
  <div>
    <div @click="toggleEditing" class="card card-body mb-3">
      {{card.name}}
    </div>

    <div v-if='editing' class="modal-backdrop show"></div>

    <div v-if='editing' @click="closeModal" class="modal show card-view">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">{{ card.name }}</h5>
          </div>
          <div class="modal-body">
            <input v-model="name" class="form-control" />
          </div>
          <div class="modal-footer">
            <button @click="save" type="button" class="btn btn-primary">Save changes</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>	

<script>
export default {
	props: ['card', 'list'],

	data() {
		return {
			editing: false,
			name: this.card.name
		}
	},

	methods: {
		toggleEditing() { this.editing = !this.editing },
		closeModal(event) {
			if (event.target.classList.contains('modal')) this.editing = false 
		},
		
		save() {
			var data = new FormData
      data.append('card[name]', this.name)

      Rails.ajax({
        url: `cards/${this.card.id}`,
        type: 'PATCH',
        data: data,
        dataType: 'json',
        success: (data) => {
					this.$store.commit('editCard', data)
					this.editing = false
        }
      })
		}
	},
}
</script>

<style>
.card-view {
	display: block;
}
</style>