class Api::Partner::CommissionsController < Api::Partner::BaseController
  def index
      commissions = Commission.where("partner_id = ?", params[:partner_id]).order("order_date desc") if params[:partner_id]
      paginate json: commissions , status: 200
  end      
end
