class Api::CouponsController < Api::BaseController
  before_action :set_coupon, only: [:show, :update, :destroy]
  before_action :authenticate_admin_or_api!

  def index
    @coupons = Coupon.all
    paginate json: @coupons, status: 200
  end

  def show
    render json: @coupon, status: 200
  end

  def by_code
    @coupon = Coupon.find_by(code: params[:code])
    authorize @coupon
    render json: @coupon, status: 200
  end

  def create
    @coupon = Coupon.new(coupon_params)
    authorize @coupon
    if @coupon.save
      render json: @coupon, status: 201
    else
      render json: { errors: @coupon.errors }, status: 422
    end
  end

  def update
    authorize @coupon
    if @coupon.update(coupon_params)
      render json: @coupon, status: 200
    else
      render json: { errors: @coupon.errors }, status: 422
    end
  end

  def destroy
    authorize @coupon
    @coupon.destroy
    head 204
  end

  private

  def set_coupon
    @coupon = Coupon.find_by(id: params[:id])
    head 404 unless @coupon
  end

  def coupon_params
    params.permit(policy(Coupon).permitted_attributes)
  end
end
