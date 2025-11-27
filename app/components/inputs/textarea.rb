# frozen_string_literal: true

module Components::Inputs
  class Textarea < Base
    def initialize(name:, id: nil, value: nil, label: nil, error: nil, span: :full, rows: 3, **attributes)
      @rows = rows
      super(name: name, id: id, value: value, label: label, error: error, span: span, **attributes)
    end

    def view_template
      render Components::Form::Field.new(
        label: @label,
        span: @span,
        error: @error,
        field_id: @id
      ) do
        textarea(
          name: @name,
          id: @id,
          rows: @rows,
          class: input_classes(error: @error),
          **input_aria_attributes,
          **@attributes
        ) do
          plain @value if @value
        end
      end
    end
  end
end
