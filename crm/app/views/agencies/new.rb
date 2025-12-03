module Views::Agencies
  class New < Views::Base

    def view_template
      div do
        h1(class: "font-bold text-4xl") { "Agencies#new" }
        p { "Find me in app/views/agencies/new.rb" }
      end
    end
  end
end