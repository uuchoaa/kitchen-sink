class Components::Select < Components::Base
  def initialize(name:, options:, selected: nil, label: nil, id: nil, disabled: false, error: false, **attributes)
    @name = name
    @options = options
    @selected = selected
    @label = label
    @id = id || name.to_s.tr("_", "-")
    @disabled = disabled
    @error = error
    @attributes = attributes
  end

  def view_template
    render_label if @label

    # Don't wrap in grid for select - chevron is inline
    select(
      name: @name,
      id: @id,
      disabled: @disabled,
      class: select_classes,
      **@attributes
    ) do
      @options.each do |option|
        render_option(option)
      end
    end
  end

  private

  def render_label
    label(for: @id, class: "block text-sm/6 font-medium text-gray-900 dark:text-white") do
      plain @label
    end
  end

  def render_option(option)
    option(
      value: option[:value],
      selected: option[:value].to_s == @selected.to_s
    ) do
      plain option[:label]
    end
  end

  def select_classes
    base = "block w-full rounded-md bg-white py-1.5 pl-3 pr-3 text-base outline outline-1 -outline-offset-1 sm:text-sm/6 dark:*:bg-gray-800"

    if @error
      "#{base} text-red-900 outline-red-300 focus:outline focus:outline-2 focus:-outline-offset-2 focus:outline-red-600 dark:bg-white/5 dark:text-red-400 dark:outline-red-500/50 dark:focus:outline-red-400"
    elsif @disabled
      "#{base} text-gray-900 outline-gray-300 focus:outline focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-gray-500 disabled:outline-gray-200 dark:bg-white/5 dark:text-gray-300 dark:outline-white/10 dark:focus:outline-indigo-500 dark:disabled:bg-white/10 dark:disabled:text-gray-500 dark:disabled:outline-white/5"
    else
      "#{base} text-gray-900 outline-gray-300 focus:outline focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 dark:bg-white/5 dark:text-white dark:outline-white/10 dark:focus:outline-indigo-500"
    end
  end
end
