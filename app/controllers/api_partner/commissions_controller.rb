class ApiPartner::CommissionsController < ApiPartner::BaseController
  before_action :authenticate_api_partner_partner!

  def index
    commissions = current_api_partner_partner.commissions.order("order_date desc")
    paginate json: commissions, status: 200
  end
end
