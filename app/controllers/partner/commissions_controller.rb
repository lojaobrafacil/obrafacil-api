class Partner::CommissionsController < Partner::BaseController
  before_action :authenticate_partner_partner!

  def index
    commissions = current_partner_partner.commissions.order("order_date desc")
    paginate json: commissions, status: 200
  end
end
