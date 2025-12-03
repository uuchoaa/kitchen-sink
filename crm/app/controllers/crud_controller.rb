class CrudController < ApplicationController
  before_action :set_model_class
  before_action :set_resource, only: [ :show, :edit, :update, :destroy ]
  layout :false

  def new
    view = view_klass.new
    view.model = model_class.new
    view.current_path = request.path
    render view
  end

  def index
  end

  def show
  end

  def update
  end

  def destroy
  end

  def edit
  end

  private

  # Infere o model class a partir do nome do controller
  # Ex: AgenciesController → Agency
  def set_model_class
    @model_class = controller_name.classify.constantize
  end

  def model_class
    @model_class
  end

  def set_resource
    @resource = model_class.find(params[:id])
  end

  def view_klass
    @view_klass ||= "Views::#{controller_name.camelize}::#{action_name.camelize}".constantize
  end

  # Permite todos os atributos exceto timestamps e id
  def resource_params
    permitted_attributes = model_class.column_names - %w[id created_at updated_at]
    params.require(model_class.model_name.param_key).permit(*permitted_attributes)
  end

  # Torna disponível para as views
  helper_method :model_class
end
