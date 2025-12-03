
module Views::Agencies
  class New < Views::Base

    def page_header
      h1(class: "font-bold text-4xl") { "Agencias" }
    end

    def main_content
      p { "Aqui vai o form e tal..." }
      p { "path = #{current_path}"}
      code { @model.to_json }
    end

  end
end