class Api::V1::OrdersController < Api::V1::BaseController

  def index
    orders = Order.all
    paginate json: orders.order(:id), status: 200
  end

  def show
    order = Order.find(params[:id])
    render json: order, status: 200
  end

  def create
    order = Order.new(order_params)
    if order.save
      render json: order, status: 201
    else
      render json: { errors: order.errors }, status: 422
    end
  end

  def update
    order = Order.find(params[:id])

    if order.update(order_params)
      render json: order, status: 200
    else
      render json: { errors: order.errors }, status: 422
    end
  end

  def destroy
    order = Order.find(params[:id])
    order.destroy
    head 204
  end

  private

  def order_params
    params.require(:order).permit( :kind, :exclusion_date, :description, :discont,
      :freight, :billing_date, :file, :price_percentage_id, :employee_id, :order_id,
      :client_id, :cashier_id, :carrier_id, :company_id)
  end
end
