# frozen_string_literal: true

module Components::Attributes
  class Base < Components::Base
    attr_reader :value, :attribute_name, :model_class

    def initialize(value:, attribute_name:, model_class:)
      @value = value
      @attribute_name = attribute_name
      @model_class = model_class
    end

    def view_template
      render_value
    end

    private

    def render_value
      plain value.to_s if value
    end
  end
end
