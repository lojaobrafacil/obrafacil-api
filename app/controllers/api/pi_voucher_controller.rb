class Api::PiVouchersController < Api::BaseController
  before_action :set_pi_voucher, only: [:show, :update]
  before_action :authenticate_admin_or_api!

  def index
    @pi_vouchers = policy_scope PiVoucher
    paginate json: @pi_vouchers, status: 200
  end

  def show
    authorize @pi_voucher
    render json: @pi_voucher, status: 200
  end

  def create
    @pi_voucher = PiVoucher.new(pi_voucher_params)
    authorize @pi_voucher
    if @pi_voucher.save
      render json: @pi_voucher, status: 201
    else
      render json: {errors: @pi_voucher.errors}, status: 422
    end
  end

  def update
    authorize @pi_voucher
    if @pi_voucher.update(pi_voucher_params)
      render json: @pi_voucher, status: 200
    else
      render json: {errors: @pi_voucher.errors}, status: 422
    end
  end

  private

  def set_pi_voucher
    @pi_voucher = PiVoucher.find_by(id: params[:id])
    head 404 unless @pi_voucher
  end

  def pi_voucher_params
    params.permit(policy(PiVoucher).permitted_attributes)
  end
end
