class Api::V2::Admin::OrdersController < Api::BaseController

  def index
    orders = policy_scope [:admin, Order]
    paginate json: orders.order(:id), status: 200
  end

  def show
    order = Order.find(params[:id])
    authorize [:admin, order]
    render json: order, status: 200
  end

  def create
    order = Order.new(order_params)
    authorize [:admin, order]
    if order.save
      render json: order, status: 201
    else
      render json: { errors: order.errors }, status: 422
    end
  end

  def update
    order = Order.find(params[:id])
    authorize [:admin, order]
    if order.update(order_params)
      render json: order, status: 200
    else
      render json: { errors: order.errors }, status: 422
    end
  end

  def destroy
    order = Order.find(params[:id])
    authorize [:admin, order]
    order.destroy
    head 204
  end

  private

  def order_params
    params.permit(policy([:admin, ::Partner]).permitted_attributes)
  end
end
