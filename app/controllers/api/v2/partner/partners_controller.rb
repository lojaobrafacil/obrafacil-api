class Api::V2::Partner::PartnersController < Api::V2::Partner::BaseController
  def index
    partner = current_api_v1_user.partner
    render json: partner, status: 200
  end
end
