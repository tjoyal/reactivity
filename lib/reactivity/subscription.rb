require 'reactivity/memory_model'

module Reactivity
  class Subscription
    include Reactivity::MemoryModel

    OPERATORS = {
      eq: :==,
      gt: :>,
      gte: :>=,
      lt: :<,
      lte: :<=,
      neq: :!=,
    }.with_indifferent_access.freeze

    attr_accessor :connection_uid, :collection, :handle, :conditions

    validate :validate_conditions

    def match?(object)
      conditions.all? do |key, condition|
        group = condition.first
        condition_operator = OPERATORS[group[0]]
        condition_value = group[1]

        value = object[key]

        match_condition?(value, condition_operator, condition_value)
      end
    end

    def subscription_objects
      scope = collection_klass.unscoped

      conditions.each do |key, condition|
        group = condition.first
        operator = OPERATORS[group[0]]
        value = group[1]

        scope = scope.where("#{key} #{operator} ?", value)
      end

      scope
    end

    private

    def collection_klass
      collection.classify.constantize
    end

    def validate_conditions
      conditions.each do |key, condition|
        unless collection_klass.attribute_names.include?(key)
          errors.add(:conditions, "Invalid key '#{key}' for collection '#{collection_klass}'")
        end

        element = condition.first
        operator = OPERATORS[element[0]]
        value = element[1]

        unless value.present?
          errors.add(:conditions, "Invalid value '#{value}' for key '#{key}' for collection '#{collection_klass}'")
        end

        unless operator
          errors.add(:conditions, "Invalid operator '#{operator}' for key '#{key}' for collection '#{collection_klass}'")
        end
      end
    end

    # todo: sanitize eval. Raw comparaison.
    def match_condition?(base_value, condition_operator, condition_value)
      if [base_value, condition_value].all? { |x| x.is_a?(Numeric) }
        base_value.send(condition_operator, condition_value)
      elsif [base_value, condition_value].all? { |x| x.is_a?(String) }
        base_value.send(condition_operator, condition_value.to_s)
      else
        raise "Impossible to convert from #{base_value.class} to #{condition_value.class}"
      end
    end
  end
end
