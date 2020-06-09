class ApiPartner::PartnersController < ApiPartner::BaseController
  def show
    @partner = Partner.find_by(id: params[:id])
    render json: @partner, status: 200, serializer: ApiPartner::PartnerSerializer
  end
end
