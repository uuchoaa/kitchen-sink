# frozen_string_literal: true

class Components::Form::Field < Components::Base
  def initialize(label: nil, span: 4, description: nil, error: nil, field_id: nil, **attributes)
    @label = label
    @span = span
    @description = description
    @error = error
    @field_id = field_id
    @attributes = attributes
  end

  def view_template(&block)
    div(class: span_class, **@attributes) do
      # Label
      if @label
        label(
          for: @field_id,
          class: "block text-sm/6 font-medium text-gray-900 dark:text-white"
        ) do
          plain @label
        end
      end

      # Input wrapper
      div(class: "mt-2") do
        yield if block_given?
      end

      # Error message
      if @error
        div(class: "mt-2 flex gap-2") do
          svg(
            viewBox: "0 0 16 16",
            fill: "currentColor",
            class: "size-4 shrink-0 text-red-500 dark:text-red-400"
          ) do |s|
            s.path(
              d: "M8 15A7 7 0 1 0 8 1a7 7 0 0 0 0 14ZM8 4a.75.75 0 0 1 .75.75v3a.75.75 0 0 1-1.5 0v-3A.75.75 0 0 1 8 4Zm0 8a1 1 0 1 0 0-2 1 1 0 0 0 0 2Z",
              clip_rule: "evenodd",
              fill_rule: "evenodd"
            )
          end

          p(
            id: "#{@field_id}-error",
            class: "text-sm text-red-600 dark:text-red-400"
          ) do
            plain @error
          end
        end
      end

      # Description/help text (only if no error)
      if @description && !@error
        p(class: "mt-3 text-sm/6 text-gray-600 dark:text-gray-400") do
          plain @description
        end
      end
    end
  end

  private

  def span_class
    case @span
    when :full, 6
      "col-span-full"
    when 2
      "sm:col-span-2"
    when 3
      "sm:col-span-3"
    when 4
      "sm:col-span-4"
    else
      "sm:col-span-#{@span}"
    end
  end
end
