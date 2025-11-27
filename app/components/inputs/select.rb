# frozen_string_literal: true

module Components::Inputs
  class Select < Base
    def initialize(name:, id: nil, options:, selected: nil, label: nil, error: nil, span: 3, **attributes)
      @options = options
      @selected = selected
      super(name: name, id: id, value: selected, label: label, error: error, span: span, **attributes)
    end

    def view_template
      render Components::Form::Field.new(
        label: @label,
        span: @span,
        error: @error,
        field_id: @id
      ) do
        render Components::Select.new(
          name: @name,
          id: @id,
          options: @options,
          selected: @selected,
          error: @error,
          **@attributes
        )
      end
    end
  end
end
