class Api::V2::OrdersController < Api::V2::Partner::BaseController

  def index
    orders = Order.all
    paginate json: orders.order(:id), status: 200
  end

  def show
    order = Order.find(params[:id])
    render json: order, status: 200
  end
end
