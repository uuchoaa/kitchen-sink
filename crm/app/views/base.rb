# frozen_string_literal: true

class Views::Base < Phlex::HTML
  # The `Views::Base` is an abstract class for all your views.

  attr_accessor :model
  attr_accessor :current_path

  def initialize(model = nil)
    @model = model
  end

  def page_header
    h1(class: "font-bold text-4xl") { "#{@model&.class.to_s.humanize}" }
  end

  def view_template
    page_header
    div do
      main_content
    end
  end

  def main_content
    raise 'It should be overrided!'
  end

  def around_template(&)
    render Cuy::DefaultLayout.new(&)
  end
end
