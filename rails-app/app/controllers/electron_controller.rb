# frozen_string_literal: true

class ElectronController < ApplicationController
  def index
    view = Views::Electron::Index.new
    view.current_path = request.path
    render view
  end
end

