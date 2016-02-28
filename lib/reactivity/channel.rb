module Reactivity
  module Channel
    def subscribed
      stream_from 'reactivity', -> (message) do
        stream_data = ActiveSupport::JSON.decode(message)

        handle_reactivity(stream_data)
      end
    end

    def unsubscribed
      Reactivity::Subscription.where(
        connection_uid: connection_uid
      ).each do |subscription|
        subscription.destroy
      end
    rescue Exception => e
      handle_exception(e)
    end

    def register(params)
      # todo: validate parameters
      handle = params['handle']
      collection = params['collection']
      conditions = params['conditions']

      subscription = Reactivity::Subscription.new(
        connection_uid: connection_uid,
        collection: collection,
        handle: handle,
        conditions: conditions
      )
      subscription.save!

      register_stream(subscription)
    rescue Exception => e
      handle_exception(e)
    end

    def unregister(params)
      # todo: validate parameters
      handle = params['handle']

      subscription = Reactivity::Subscription.where(
        connection_uid: connection_uid,
        handle: handle
      ).first

      if subscription
        unregister_stream(subscription)
        subscription.destroy
      end
    rescue Exception => e
      handle_exception(e)
    end

    private

    def register_stream(subscription)
      action_objects(subscription).each do |object|
        data = object.reactivity_data
        transmit_data data, via: :register
      end
    end

    def unregister_stream(subscription)
      action_objects(subscription).each do |object|
        data = object.reactivity_data(destroyed: true)
        transmit_data data, via: :unregister
      end
    end

    def action_objects(subscription)
      other_subscriptions = Reactivity::Subscription.where(
        connection_uid: connection_uid,
        collection: subscription.collection
      ).reject { |x|
        x.handle == subscription.handle
      }

      subscription.subscription_objects.reject do |object|
        other_subscriptions.any? { |other_subscription| other_subscription.match?(object) }
      end
    end

    def connection_uid
      connection.object_id
    end

    def handle_reactivity(stream_data)
      subscriptions = Reactivity::Subscription.where(
        connection_uid: connection_uid,
        collection: stream_data['collection']
      )

      if subscriptions.any? { |subscription| subscription.match?(stream_data['payload']) }
        # todo: distinct internal from external data
        transmit_data stream_data, via: :broadcast
      end
    rescue Exception => e
      handle_exception(e)
    end

    def handle_exception(e)
      return unless Reactivity.stream_exceptions

      Reactivity.logger.error e.message
      Reactivity.logger.error e.backtrace.join("\n")

      data = {
        message: "Exception: #{e.message}",
      }

      transmit_system data, via: :error_handling
    end

    def transmit_data(data, via:)
      payload = data.merge(
        kind: 'data',
      )

      transmit payload, via: "Reactivity::#{via.capitalize}"
    end

    def transmit_system(data, via:)
      payload = data.merge(
        kind: 'system',
      )

      transmit payload, via: "Reactivity::#{via.capitalize}"
    end
  end
end
