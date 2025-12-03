class AgenciesController < ApplicationController
  layout :false

  def new
    agency = Agency.new

    view = Views::Agencies::New.new
    view.model = agency
    view.current_path = request.path
    render view
  end

  def index
  end
end
