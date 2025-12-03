class AgenciesController < ApplicationController
  def new
    view = Views::Agencies::New.new
    render view
  end

  def index
  end
end
