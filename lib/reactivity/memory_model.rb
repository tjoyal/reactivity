module Reactivity
  module MemoryModel
    extend ActiveSupport::Concern

    included do |base|
      base.cattr_accessor :memory
      base.memory = {}

      base.cattr_accessor :next_identity
      base.next_identity = 1

      base.cattr_accessor :lock
      base.lock = Mutex.new

      base.include ActiveModel::Model
      base.extend ClassMethods
    end

    module ClassMethods
      def where(args)
        memory.select do |_id, object|
          args.all? do |key, value|
            object.send(key) == value
          end
        end.values
      end
    end

    attr_accessor :id

    def save
      raise "Cannot save an object already in memory (memory objects should not be edited)" if in_memory?

      return false unless valid?

      lock.synchronize do
        @id = self.class.next_identity
        self.class.next_identity += 1

        memory[id] = self
      end

      true
    end

    def save!
      return if save

      raise errors.full_messages.to_sentence
    end

    def destroy
      raise "Cannot forget an object that is not yet memorized" unless in_memory?

      lock.synchronize do
        memory.delete(id)
      end

      true
    end

    private

    def in_memory?
      id.present?
    end
  end
end
