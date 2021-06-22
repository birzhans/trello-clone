require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("local-time").start()

window.Rails = Rails

import 'bootstrap'
import Vue from 'vue/dist/vue.esm'
import App from '../app.vue'

window.store = {}

document.addEventListener("turbolinks:load", () => {
  var element = document.querySelector("#boards")

  if (element != undefined) {

    window.store.lists = JSON.parse(element.dataset.lists) 
    const app = new Vue({
      el: element,
      data: window.store,
      template: "<App :original_lists='lists' />",
      components: { App }
    })
  }
})
