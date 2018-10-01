class Api::V2::Partner::CommissionsController < Api::V2::Partner::BaseController
  def index
      commissions = Commission.where("partner_id = ?", params[:partner_id]).order("order_date desc") if params[:partner_id]
      paginate json: commissions , status: 200
  end      
end
