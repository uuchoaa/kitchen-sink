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
              render Components::Form.new(action: deals_path, method: :post) do |form|
                form.section(
                  title: "Informações Básicas",
                  description: "Dados principais do deal"
                ) do |section|
                  section.text :title,
                    label: "Título",
                    span: 4,
                    placeholder: "Ex: Desenvolvedor Senior Ruby"

                  section.email :contact_email,
                    label: "Email de contato",
                    span: 4,
                    placeholder: "contato@example.com"

                  section.select :agency_id,
                    label: "Agência",
                    span: 3,
                    options: agencies.map { |a| { value: a.id, label: a.name } },
                    selected: deal.agency_id

                  section.select :recruter_id,
                    label: "Recrutador",
                    span: 3,
                    options: recruiters.map { |r| { value: r.id, label: r.name } },
                    selected: deal.recruter_id

                  section.select :stage,
                    label: "Estágio",
                    span: 3,
                    options: Deal.stages.keys.map { |s| { value: s, label: Deal.human_attribute_name("stage.#{s}") } },
                    selected: deal.stage

                  section.textarea :description,
                    label: "Descrição",
                    span: :full,
                    rows: 4,
                    placeholder: "Descreva o deal...",
                    description: "Adicione detalhes sobre a vaga e o candidato",
                    value: deal.description
                end

                form.section(
                  title: "Campos Customizados",
                  description: "Exemplo de campo customizado com wrapper"
                ) do |section|
                  section.field(label: "Campo especial", span: :full) do
                    div(class: "flex gap-4") do
                      input(
                        type: "text",
                        placeholder: "Parte 1",
                        class: "block w-full rounded-md bg-white px-3 py-1.5 text-base text-gray-900 outline outline-1 -outline-offset-1 outline-gray-300"
                      )
                      input(
                        type: "text",
                        placeholder: "Parte 2",
                        class: "block w-full rounded-md bg-white px-3 py-1.5 text-base text-gray-900 outline outline-1 -outline-offset-1 outline-gray-300"
                      )
                    end
                  end
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
