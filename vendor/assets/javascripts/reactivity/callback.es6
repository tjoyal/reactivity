class Callback {
  constructor(collection, callback) {
    this.collection = collection;
    this.callback = callback;

    this.handle = Util.guid();

    this.register();
  }

  stop() {
    delete this.collection.onChangeCallbacks[this.handle];
  }

  // Private

  register() {
    this.collection.onChangeCallbacks[this.handle] = this.callback;
  }
}
