class Api::PiVouchersController < Api::BaseController
  before_action :set_pi_voucher, only: [:show, :send_email, :used, :received, :inactivate]
  before_action :authenticate_admin_or_api!

  def index
    if params[:partner_id]
      @pi_vouchers = policy_scope(PiVoucher) ? policy_scope(PiVoucher).where(partner_id: params[:partner_id]).order(updated_at: :desc) : nil
      paginate json: @pi_vouchers, status: 200
    else
      render json: { errors: "partner_id is required" }, status: 404
    end
  end

  def show
    authorize @pi_voucher
    render json: @pi_voucher, status: 200
  end

  def send_email
    authorize @pi_voucher
    begin
      if !@pi_voucher.inactive? && !@pi_voucher.used?
        PiVoucherEmailsWorker.perform_async(@pi_voucher.id)
        render json: { email: I18n.t("models.pi_voucher.response.email.success") }, status: 200
      else
        render json: { errors: { error: I18n.t("models.pi_voucher.response.email.not_send") } }, status: 422
      end
    rescue
      render json: { errors: { error: I18n.t("models.pi_voucher.response.email.error") } }, status: 422
    end
  end

  def create
    @pi_voucher = PiVoucher.new(params.permit(:value, :partner_id))
    authorize @pi_voucher
    if @pi_voucher.save
      render json: @pi_voucher, status: 201
    else
      render json: { errors: @pi_voucher.errors }, status: 422
    end
  end

  def used
    authorize @pi_voucher
    if !@pi_voucher.inactive? && @pi_voucher.used?
      if @pi_voucher.update(used_at: Time.now, status: "used", company_id: params.permit(:company_id)[:company_id])
        render json: @pi_voucher, status: 200
      end
    else
      render json: { errors: { error: I18n.t("models.pi_voucher.response.used.error") } }, status: 422
    end
  end

  def inactivate
    authorize @pi_voucher
    if !@pi_voucher.inactive? && !@pi_voucher.used? && @pi_voucher.received_at.nil?
      if @pi_voucher.update(status: "inactive")
        render json: @pi_voucher, status: 200
      end
    else
      render json: { errors: { error: I18n.t("models.pi_voucher.response.inactivate.error") } }, status: 422
    end
  end

  def received
    authorize @pi_voucher
    if !@pi_voucher.inactive? && @pi_voucher.received_at.nil?
      if @pi_voucher.update(received_at: Time.now)
        render json: @pi_voucher, status: 200
      end
    else
      render json: { errors: { error: I18n.t("models.pi_voucher.response.received.error") } }, status: 422
    end
  end

  private

  def set_pi_voucher
    @pi_voucher = PiVoucher.find_by(id: params[:id])
    head 404 unless @pi_voucher
  end
end
