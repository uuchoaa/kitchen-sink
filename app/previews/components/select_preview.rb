# frozen_string_literal: true

class Components::SelectPreview < ComponentPreview
  preview :default,
    name: "Default",
    description: "Select básico sem label e sem valor pré-selecionado. Mostra o placeholder 'Selecione...' até que o usuário escolha uma opção.",
    code: %(Components::Select.new(
  name: "status",
  options: [
    { value: "active", label: "Ativo" },
    { value: "inactive", label: "Inativo" },
    { value: "pending", label: "Pendente" }
  ]
)) do
    Components::Select.new(
      name: "status",
      options: [
        { value: "active", label: "Ativo" },
        { value: "inactive", label: "Inativo" },
        { value: "pending", label: "Pendente" }
      ]
    )
  end

  preview :with_label,
    name: "Com Label",
    description: "Select com label descritiva acima do campo. Use quando o contexto do campo não estiver claro apenas pelo placeholder.",
    code: %(Components::Select.new(
  name: "priority",
  label: "Prioridade",
  options: [
    { value: "low", label: "Baixa" },
    { value: "medium", label: "Média" },
    { value: "high", label: "Alta" }
  ]
)) do
    Components::Select.new(
      name: "priority",
      label: "Prioridade",
      options: [
        { value: "low", label: "Baixa" },
        { value: "medium", label: "Média" },
        { value: "high", label: "Alta" }
      ]
    )
  end

  preview :with_selected,
    name: "Com Valor Selecionado",
    description: "Select com um valor pré-selecionado. Útil para formulários de edição onde você quer mostrar o valor atual do registro.",
    code: %(Components::Select.new(
  name: "stage",
  label: "Estágio",
  selected: "screening",
  options: [
    { value: "open", label: "Aberto" },
    { value: "screening", label: "Triagem" },
    { value: "interview", label: "Entrevista" },
    { value: "offer", label: "Proposta" }
  ]
)) do
    Components::Select.new(
      name: "stage",
      label: "Estágio",
      selected: "screening",
      options: [
        { value: "open", label: "Aberto" },
        { value: "screening", label: "Triagem" },
        { value: "interview", label: "Entrevista" },
        { value: "offer", label: "Proposta" }
      ]
    )
  end

  preview :many_options,
    name: "Com Muitas Opções",
    description: "Select com lista longa de opções. O componente automaticamente adiciona scroll quando necessário (max-height: 60).",
    code: %(Components::Select.new(
  name: "country",
  label: "País",
  options: [
    { value: "br", label: "Brasil" },
    { value: "ar", label: "Argentina" },
    { value: "us", label: "Estados Unidos" },
    { value: "uk", label: "Reino Unido" },
    { value: "fr", label: "França" },
    { value: "de", label: "Alemanha" },
    { value: "jp", label: "Japão" },
    { value: "cn", label: "China" },
    { value: "in", label: "Índia" },
    { value: "au", label: "Austrália" }
  ]
)) do
    Components::Select.new(
      name: "country",
      label: "País",
      options: [
        { value: "br", label: "Brasil" },
        { value: "ar", label: "Argentina" },
        { value: "us", label: "Estados Unidos" },
        { value: "uk", label: "Reino Unido" },
        { value: "fr", label: "França" },
        { value: "de", label: "Alemanha" },
        { value: "jp", label: "Japão" },
        { value: "cn", label: "China" },
        { value: "in", label: "Índia" },
        { value: "au", label: "Austrália" }
      ]
    )
  end
end
