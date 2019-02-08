class Api::OrdersController < Api::BaseController
  before_action :authenticate_admin_or_api!

  def index
    @orders = policy_scope Order
    paginate json: @orders.order(:id), status: 200
  end

  def show
    @order = Order.find_by(id: params[:id])
    if @order
      authorize @order
      render json: @order, status: 200
    else
      head 404
    end
  end

  def create
    @order = Order.new(order_params)
    authorize @order
    if @order.save
      render json: @order, status: 201
    else
      render json: {errors: @order.errors}, status: 422
    end
  end

  def update
    @order = Order.find(params[:id])
    authorize @order
    if @order.update(order_params)
      render json: @order, status: 200
    else
      render json: {errors: @order.errors}, status: 422
    end
  end

  def destroy
    @order = Order.find(params[:id])
    authorize @order
    @order.destroy
    head 204
  end

  private

  def order_params
    params.permit(policy(Order).permitted_attributes)
  end
end
