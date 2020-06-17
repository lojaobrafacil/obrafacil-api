class ApiPartner::EventsController < ApiPartner::BaseController
  def show
    event = Highlight.find_by(kind: "event", id: params[:id])
    render json: event, status: 200, serializer: ApiPartner::EventSerializer
  end
end
