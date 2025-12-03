module Views::Agencies
  class New < Views::Base

    def main_content
      p { "Aqui vai o form e tal..." }
      code { @model.to_json }
    end

  end
end