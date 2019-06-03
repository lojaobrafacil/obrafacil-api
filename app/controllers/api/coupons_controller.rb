class Api::CouponsController < Api::BaseController
  before_action :set_coupon, only: [:show, :update, :destroy]
  before_action :set_coupon_by_code, only: [:use, :by_code]
  before_action :authenticate_admin_or_api!

  def index
    @coupons = Coupon.all
    @coupons = @coupons.where("LOWER(name) like LOWER('%#{params[:name]}%')") if params[:name] && !params[:name].empty?
    @coupons = @coupons.where("LOWER(code) like LOWER('%#{params[:code]}%')") if params[:code] && !params[:code].empty?
    @coupons = @coupons.where(status: params[:status]) if params[:status] && !params[:status].empty?
    paginate json: @coupons, status: 200
  end

  def show
    render json: @coupon, status: 200
  end

  def by_code
    authorize @coupon
    if params[:client_federal_registration] && @coupon.client_uses != 0
      num_of_use_by_client = @coupon.logs.where(client_federal_registration: params[:client_federal_registration]).count
      @coupon.status = "inactive" if num_of_use_by_client >= @coupon.client_uses
    end
    render json: @coupon, status: 200, serializer: Api::CouponByCodeSerializer
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

  def use
    if @coupon.use(coupon_params_to_use)
      render json: { success: I18n.t("models.coupon.response.used") }, status: 200
    else
      render json: { errors: @coupon.errors.values.join(", ") }, status: 422
    end
  end

  private

  def set_coupon
    @coupon = Coupon.find_by(id: params[:id])
    head 404 unless @coupon
  end

  def set_coupon_by_code
    @coupon = Coupon.find_by(code: params[:code])
    render(json: { errors: I18n.t("models.coupon.errors.not_found") }, status: 404) if @coupon.nil?
  end

  def coupon_params
    params.permit(policy(Coupon).permitted_attributes)
  end

  def coupon_params_to_use
    params.permit(:external_order_id, :client_federal_registration)
  end
end
