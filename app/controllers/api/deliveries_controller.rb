class Api::DeliveriesController < Api::BaseController
  before_action :authenticate_admin_or_api!

  def index
    @deliveries = policy_scope Delivery
    paginate json: @deliveries, status: 200, each_serializer: Api::DeliverySerializer
  end

  def show
    @delivery = Delivery.find_by(id: params[:id])
    if @delivery
      render json: @delivery, status: 200
    else
      head 404
    end
  end

  def create
    @delivery = Delivery.new(delivery_params)
    authorize @delivery
    if @delivery.save
      render json: @delivery, status: 201
    else
      render json: { errors: @delivery.errors.full_messages }, status: 422
    end
  end

  def update
    @delivery = Delivery.find(params[:id])
    authorize @delivery
    if @delivery.update(delivery_params)
      render json: @delivery, status: 200
    else
      render json: { errors: @delivery.errors.full_messages }, status: 422
    end
  end

  private

  def delivery_params
    params.permit(
      :order_id, :external_order_id, :recipient, :driver_id, :checker_id,
      :phone, :email, :checked_at, :freight, :status, :expected_delivery_in,
      :street, :zipcode, :complement, :neighborhood, :delivered_at, :left_delivery_at,
      :remark, :city_id
    )
  end
end
