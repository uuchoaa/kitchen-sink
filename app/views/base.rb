# frozen_string_literal: true

class Views::Base < Components::Base
  include Phlex::Rails::Helpers::CSRFMetaTags
  include Phlex::Rails::Helpers::StyleSheetLinkTag
  include Phlex::Rails::Helpers::JavaScriptImportmapTags

  def around_template
    doctype

    html(class: "bg-white h-full") do
      head do
        title { page_title || "Resume" }

        meta(name: "viewport", content: "width=device-width,initial-scale=1")
        meta(name: "apple-mobile-web-app-capable", content: "yes")
        meta(name: "application-name", content: "Resume")
        meta(name: "mobile-web-app-capable", content: "yes")

        link(rel: "icon", href: "/icon.png", type: "image/png")
        link(rel: "icon", href: "/icon.svg", type: "image/svg+xml")
        link(rel: "apple-touch-icon", href: "/icon.png")

        csrf_meta_tags
        stylesheet_link_tag :app, "data-turbo-track": "reload"
        javascript_importmap_tags
      end

      body(class: "bg-white h-full") do
        div(class: "min-h-full") do
          render_navbar

          div(class: "py-10") do
            header do
              div(class: "mx-auto max-w-7xl px-4 sm:px-6 lg:px-8") do
                h1(class: "text-3xl font-bold leading-tight text-gray-900") { page_header }
              end
            end

            main(class: "mx-auto max-w-7xl px-4 sm:px-6 lg:px-8") do
              yield
            end
          end
        end
      end
    end
  end

  def page_header
    page_title
  end

  private

  def render_navbar
    # render Views::Shared::Navbar.new
  end
end
