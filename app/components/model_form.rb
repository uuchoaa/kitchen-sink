# frozen_string_literal: true

class Components::ModelForm < Components::Form
  attr_reader :model

  def initialize(model:, action: nil, method: nil, **attributes)
    @model = model

    # Determina method baseado no model se não fornecido
    if method.nil?
      method = model.persisted? ? :patch : :post
    end

    super(action: action, method: method, **attributes)
  end

  # Override field_name para incluir o namespace do model
  def field_name(name)
    "#{model_param_key}[#{name}]"
  end

  # Override field_id para incluir o namespace do model
  def field_id(name)
    "#{model_param_key}_#{name}"
  end

  # Override field_value para pegar do model se não fornecido explicitamente
  def field_value(name, explicit_value)
    return explicit_value unless explicit_value.nil?

    model.public_send(name) if model.respond_to?(name)
  end

  # Método para obter erros do model
  def field_error(name)
    return nil unless model.errors.any?

    errors = model.errors[name]
    errors.first if errors.any?
  end

  private

  def model_param_key
    @model.model_name.param_key
  end
end
