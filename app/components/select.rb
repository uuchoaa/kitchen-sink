class Components::Select < Components::Base
  def initialize(name:, options:, selected: nil, label: nil, id: nil)
    @name = name
    @options = options
    @selected = selected
    @label = label
    @id = id || "select_#{name}_#{rand(1000)}"
    
    # Busca o label da opção selecionada
    @selected_label = if @selected
      option = @options.find { |opt| opt[:value].to_s == @selected.to_s }
      option ? option[:label] : nil
    else
      nil
    end
  end

  def view_template
    render_label if @label
    render_wrapper
  end

  private

  def render_label
    label(for: @id, class: "block text-sm font-medium text-gray-900") do
      plain @label
    end
  end

  def render_wrapper
    div(data_controller: "select", class: "relative mt-2") do
      render_button
      render_menu
      render_hidden_input
    end
  end

  def render_button
    button(
      type: "button",
      data_select_target: "button",
      data_action: "click->select#toggle",
      class: "grid w-full grid-cols-1 rounded-md bg-white py-1.5 pl-3 pr-2 text-left text-gray-900 outline outline-1 -outline-offset-1 outline-gray-300 focus-visible:outline focus-visible:outline-2 focus-visible:-outline-offset-2 focus-visible:outline-indigo-600 text-sm"
    ) do
      span(
        data_select_target: "selectedText",
        class: "col-start-1 row-start-1 truncate pr-6"
      ) do
        plain(@selected_label || "Selecione...")
      end
      
      # SVG Chevron
      svg(
        viewBox: "0 0 16 16",
        fill: "currentColor",
        class: "col-start-1 row-start-1 size-5 self-center justify-self-end text-gray-500"
      ) do |s|
        s.path(
          d: "M5.22 10.22a.75.75 0 0 1 1.06 0L8 11.94l1.72-1.72a.75.75 0 1 1 1.06 1.06l-2.25 2.25a.75.75 0 0 1-1.06 0l-2.25-2.25a.75.75 0 0 1 0-1.06ZM10.78 5.78a.75.75 0 0 1-1.06 0L8 4.06 6.28 5.78a.75.75 0 0 1-1.06-1.06l2.25-2.25a.75.75 0 0 1 1.06 0l2.25 2.25a.75.75 0 0 1 0 1.06Z",
          clip_rule: "evenodd",
          fill_rule: "evenodd"
        )
      end
    end
  end

  def render_menu
    div(
      data_select_target: "menu",
      class: "hidden absolute z-10 mt-1 w-full max-h-60 overflow-auto rounded-md bg-white py-1 text-sm shadow-lg outline outline-1 outline-black/5"
    ) do
      @options.each do |option|
        render_option(option)
      end
    end
  end

  def render_option(option)
    is_selected = option[:value].to_s == @selected.to_s

    div(
      data_select_target: "option",
      data_value: option[:value],
      data_label: option[:label],
      data_action: "click->select#selectOption",
      class: "relative cursor-pointer select-none py-2 pl-3 pr-9 text-gray-900 hover:bg-indigo-600 hover:text-white"
    ) do
      span(class: "block truncate") do
        plain option[:label]
      end

      # Checkmark icon (só aparece se selecionado)
      if is_selected
        span(class: "absolute inset-y-0 right-0 flex items-center pr-4 text-indigo-600") do
          svg(
            viewBox: "0 0 20 20",
            fill: "currentColor",
            class: "size-5"
          ) do |s|
            s.path(
              d: "M16.704 4.153a.75.75 0 0 1 .143 1.052l-8 10.5a.75.75 0 0 1-1.127.075l-4.5-4.5a.75.75 0 0 1 1.06-1.06l3.894 3.893 7.48-9.817a.75.75 0 0 1 1.05-.143Z",
              clip_rule: "evenodd",
              fill_rule: "evenodd"
            )
          end
        end
      end
    end
  end

  def render_hidden_input
    input(
      type: "hidden",
      name: @name,
      value: @selected || "",
      data_select_target: "hiddenInput"
    )
  end
end
