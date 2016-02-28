class Subscription {
  constructor(collection, conditions) {
    this.collection = collection;
    this.conditions = conditions;
    this.handle = Util.guid();

    this.register();
  }

  stop() {
    console.log(`Unregister collection '${this.collection.name}' with handle '${this.handle}'`);

    return this.collection.reactivity.perform("unregister", {handle: this.handle});
  }

  // private

  register() {
    console.log(`Register collection '${this.collection.name}' with handle '${this.handle}'`, this.conditions);

    return this.collection.reactivity.perform("register", {handle: this.handle, collection: this.collection.name, conditions: this.conditions});
  }
}
