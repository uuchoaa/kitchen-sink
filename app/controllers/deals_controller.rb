class DealsController < CrudController
  # GET /deals/kanban
  def kanban
    view = Views::Deals::Kanban.new
    view.current_path = request.path
    view.data = Deal.includes(:agency, :recruter).all
    view.current_path = request.path
    render view
  end
end
