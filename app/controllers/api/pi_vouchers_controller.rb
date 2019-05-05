class Api::PiVouchersController < Api::BaseController
  before_action :set_pi_voucher, only: [:show, :send_email, :update, :generate_pdf]
  before_action :authenticate_admin_or_api!

  def index
    if params[:partner_id]
      @pi_vouchers = policy_scope(PiVoucher).where(partner_id: params[:partner_id]).order(updated_at: :desc) rescue nil
      paginate json: @pi_vouchers, status: 200 rescue render json: { errors: { error: I18n.t("models.pi_voucher.errors.not_found") } }, status: 422
    else
      render json: { errors: { error: I18n.t("models.pi_voucher.errors.partner_id") } }, status: 422
    end
  end

  def by_status
    case params[:status]
    when "not_used"
      @pi_vouchers = policy_scope(PiVoucher)&.where(status: "active")
    when "used_not_received"
      @pi_vouchers = policy_scope(PiVoucher)&.where(received_at: nil, status: "used")
    when "used_received"
      @pi_vouchers = policy_scope(PiVoucher)&.where.not(received_at: nil, status: ["active", "inactive"]) rescue nil
    else
      @pi_voucher = []
    end
    paginate json: @pi_vouchers, status: 200 rescue render json: { errors: { error: I18n.t("models.pi_voucher.errors.not_found") } }, status: 422
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

  def generate_pdf
    @pi_voucher.generate_pdf
    if @pi_voucher.generate_pdf
      render json: { success: "true" }, status: 200
    else
      render json: { errors: { error: "false" } }, status: 422
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

  def update
    authorize @pi_voucher
    case params[:status]
    when "used"
      @pi_voucher.assign_attributes(used_at: Time.now, status: "used", company_id: params.permit(:company_id)[:company_id])
    when "inactivate"
      @pi_voucher.assign_attributes(status: "inactive")
    when "received"
      @pi_voucher.assign_attributes(received_at: Time.now)
    end
    if @pi_voucher.save
      render json: @pi_voucher, status: 200
    else
      render json: { errors: @pi_voucher.errors }, status: 422
    end
  end

  private

  def set_pi_voucher
    @pi_voucher = PiVoucher.find_by(id: params[:id])
    head 404 unless @pi_voucher
  end
end
