# Reactivity

TODO: And describe your gem


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'reactivity'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install reactivity

## Usage

Initializer

```
# config/initializers/reactivity.rb
Reactivity.logger = Rails.logger
Reactivity.stream_exceptions = true
```


Enabling the channel

```
# app/channels/reactivity_channel.rb
class ReactivityChannel < ApplicationCable::Channel
  include Reactivity::Channel
end
```


Linking models

```
# app/models/example.rb
class Example < ApplicationRecord
  include Reactivity::Hooks
end
```


Client side

```
// TODO: api still being worked on.
// Not quite certain of the balance between simplicity and flexibility
// Right now feel the focus should be functionnality and we can just do a small breaking change at some point

// For now, it looks like that:

reactivity = new Reactivity( function () {

    // Registration
    collection = reactivity.getCollection('example');

    // Callback
    changeHandle = collection.onChange( function (data) {
      console.log("Change callback called");
    });

    // Subscription
    subscriptionHandle = collection.subscribe({ pos_x: { lt: 25 }});

    // Callback Stop
    setTimeout( function () {
      changeHandle.stop();
    }, 5000);

    // Subscription Stop
    setTimeout( function () {
      subscriptionHandle.stop();
    }, 10000);
});
```

Cable.yml

Would need some investigation but it seems to be an incompatibility with the `async` adapter integration.
The `redis` one works as expected.


## Roadmap

See `ROADMAP.md`


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tjoyal/reactivity.

Contribution can also be achieved by sharing your use cases so the the project evolve in the right direction.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
