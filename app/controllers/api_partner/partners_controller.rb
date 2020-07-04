class ApiPartner::PartnersController < ApiPartner::BaseController
  def index
    @partners = ::Partner.most_scored_month
    paginate json: @partners, status: 200, each_serializer: ApiPartner::PartnersSerializer
  end

  def show
    @partner = ::Partner.find_by(id: params[:id])
    render json: @partner, status: 200, serializer: ApiPartner::PartnerSerializer
  end

  def send_email
    @partner = ::Partner.find_by(id: params[:id])
    PartnerMailer.client_needs_more_information(@partner, send_email_params).deliver_now
    render json: { success: "Email enviado a #{@partner.name}" }, status: 200
  end

  private

  def send_email_params
    params.permit(:name, :email, :subject, :message)
  end
end
