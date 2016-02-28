module Reactivity
  module Hooks
    extend ActiveSupport::Concern

    included do
      after_create :reactivity_after_create
      after_update :reactivity_after_update
      after_destroy :reactivity_after_destroy
    end

    def reactivity_broadcast(destroyed: false)
      ActionCable.server.broadcast 'reactivity', reactivity_data(destroyed: destroyed)
    end

    def reactivity_data(destroyed: false)
      payload = to_reactivity

      raise 'Missing required argument id' unless payload[:id]

      {
        destroyed: destroyed,
        collection: self.class.name.underscore,
        payload: payload
      }
    end

    private

    def reactivity_after_create
      reactivity_broadcast
    end

    def reactivity_after_update
      reactivity_broadcast
    end

    def reactivity_after_destroy
      reactivity_broadcast(destroyed: true)
    end

    def to_reactivity
      raise StandardError, "Need to implement '#{__method__}' for class '#{self.class.name}'"
    end
  end
end
