module Views
  module Deals
    class New < Views::Base
      attr_accessor :deal, :agencies, :recruiters

      def page_title
        "Novo Deal"
      end

      def view_template
        render Components::PageHeader.new(page_title)

        div(class: "mt-8 max-w-4xl mx-auto") do
          div(class: "bg-white shadow-sm ring-1 ring-gray-900/5 sm:rounded-xl") do
            div(class: "px-4 py-6 sm:p-8") do
              render Components::Form.new(action: deals_path, method: :post, model: deal) do |form|
                form.section(
                  title: "Informações do Deal",
                  description: "Preencha os dados do novo deal"
                ) do |section|
                  section.select :agency_id,
                    label: "Agência",
                    span: 3,
                    options: agencies.map { |a| { value: a.id, label: a.name } }

                  section.select :recruter_id,
                    label: "Recrutador",
                    span: 3,
                    options: recruiters.map { |r| { value: r.id, label: r.name } }

                  section.select :stage,
                    label: "Estágio",
                    span: 3,
                    options: Deal.stages.keys.map { |s| { value: s, label: Deal.human_attribute_name("stage.#{s}") } }

                  section.textarea :description,
                    label: "Descrição",
                    span: :full,
                    rows: 4,
                    placeholder: "Descreva o deal..."
                end

                form.action_buttons do |actions|
                  actions.cancel "Cancelar"
                  actions.submit "Criar Deal"
                end
              end
            end
          end
        end
      end
    end
  end
end
