# frozen_string_literal: true

module Components::Attributes
  class HasManyAttribute < Components::Attributes::Base
    attr_reader :association

    def initialize(value:, attribute_name:, model_class:, association:)
      super(value: value, attribute_name: attribute_name, model_class: model_class)
      @association = association
    end

    private

    def render_value
      return unless value

      count = value.count
      plain "#{count} #{association.klass.model_name.human(count: count)}"
    end
  end
end
