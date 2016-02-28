class Reactivity {
  constructor(ready) {
    this.collections = {};
    this.cable = ActionCable.createConsumer();

    var base = this;

    // todo: move these options in the constructor api and only hijack the received?
    this.connection = this.cable.subscriptions.create('ReactivityChannel', {
      connected: function() {
        ready()
      },
      disconnected: function() {
        // Noop
      },
      rejected: function() {
        // Noop
      },
      received: function(data) {
        base.received(data)
      }
    });
  }

  getCollection(name) {
    if (!this.collections[name])
      this.collections[name] = new Collection(this.connection, name);

    return this.collections[name];
  }

  // private

  received(data) {
    switch (data.kind) {
      case 'data':
        var collection = data.collection;
        var payload = data.payload;
        var destroyed = data.destroyed;

        this.getCollection(collection).process(payload, destroyed);
        break;
      case 'system':
        console.log("[System]", data.message);
        break;
      default:
        console.log("Received message from unknown kind", data);
    }
  }
}
