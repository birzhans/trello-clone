import consumer from "./consumer"

consumer.subscriptions.create("BoardChannel", {
  connected() {
  },

  disconnected() {
  },

  received(data) {
    if (data.commit) {
      return window.store.commit(data.commit, JSON.parse(data.payload));
    }
  }
});
