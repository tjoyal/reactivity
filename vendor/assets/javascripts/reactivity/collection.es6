class Collection {
  constructor(reactivity, name) {
    this.reactivity = reactivity;
    this.name = name;
    this.objects = {};
    this.networkOperations = 0;

    // Would be a hash but we do not have anything to put in the key as a back ref yet
    this.onChangeCallbacks = [];
  }

  subscribe(conditions) {
    return new Subscription(this, conditions);
  }

  onChange(callback) {
    return new Callback(this, callback);
  }

  // private

  process(payload, destroyed) {
    var objectId = payload.id;

    var object = new WrapObject(payload);

    // todo: wrap object here
    // Instead of override, do an update so reference does not get lost?
    // Server could/should send only "changed" values
    this.objects[objectId] = object;

    if (destroyed)
      delete this.objects[objectId];

    this.networkOperations += 1;

    for (let key of Object.keys(this.onChangeCallbacks)) {
      this.onChangeCallbacks[key](object, destroyed)
    }
  }
}
