class Api::Partner::PartnersController < Api::Partner::BaseController
  def index
    partner = current_api_client_user.partner
    render json: partner, status: 200
  end
end
