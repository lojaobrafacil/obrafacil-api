class Api::PiVouchersController < Api::BaseController
  before_action :set_pi_voucher, only: [:show, :update]
  before_action :authenticate_admin_or_api!

  def index
    if params[:partner_id]
      @pi_vouchers = policy_scope(PiVoucher)&.where(partner_id: params[:partner_id])
      paginate json: @pi_vouchers.order(updated_at: :desc), status: 200
    else
      render json: "partner_id is required", status: 404
    end
  end

  def show
    authorize @pi_voucher
    respond_with do |format|
      format.json { render json: @pi_voucher, status: 200 }
      format.pdf do
        pdf = PdfPiVoucher.new(Rails.root.join("public/pdf.pdf"), @pi_voucher).render
        file = File.new(Rails.root.join("public/pdf.pdf"))
        send_data file,
                  filename: "VOUCHER_#{@pi_voucher.id}.pdf",
                  type: "application/pdf"
        File.delete(Rails.root.join("public/pdf.pdf"))
      end
    end
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
