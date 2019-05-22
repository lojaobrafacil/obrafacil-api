class Partner::CommissionsController < Partner::BaseController
  before_action :authenticate_partner_user!
  def index
    commissions = Commission.where("partner_id = ?", params[:partner_id]).order("order_date desc") if params[:partner_id]
    paginate json: commissions, status: 200
  end
end
