class Api::PartnersController < Api::BaseController
  before_action :authenticate_admin_or_api!
  before_action :set_partner, only: [:show, :update, :destroy, :reset, :reset_password]

  def index
    begin
      @partners = ::Partner.statuses.keys.include?(params[:status]) ? ::Partner.where(status: params[:status]) : ::Partner.all
      if @partners&.empty? or @partners.nil?
        render json: @partners, status: 200
      else
        query = []
        query << "LOWER(name) LIKE LOWER('%#{params[:name]}%')" if params[:name]
        query << "federal_registration LIKE '#{params[:federal_registration]}%'" if params[:federal_registration]
        query << "partner_group_id= #{params[:partner_group_id]}" if params[:partner_group_id]
        @partners = params.empty? ? @partners : @partners.where(query.join(" and "))
        paginate json: @partners.order(:name).as_json(only: [:id, :name, :federal_registration, :state_registration, :active, :status, :description, :cash_redemption]), status: 200
      end
    rescue
      render json: { errors: I18n.t("models.partner.errors.rescue") }, status: 404
    end
  end

  def show
    render json: @partner, status: 200
  end

  def create
    @partner = ::Partner.new(partner_params)
    if @partner.save
      render json: @partner, status: 201
    else
      render json: { errors: @partner.errors }, status: 422
    end
  end

  def update
    if @partner.update(partner_params)
      render json: @partner, status: 200
    else
      render json: { errors: @partner.errors }, status: 422
    end
  end

  def destroy
    user = @partner.user
    @partner.destroy
    user.destroy if !user.client
    head 204
  end

  def reset_password
    authorize @partner
    user = @partner.user
    if user&.reset_password(params[:password], params[:password_confirmation])
      render json: { success: I18n.t("models.partner.response.reset_password.success") }, status: 201
    else
      render json: { errors: I18n.t("models.partner.response.reset_password.error") }, status: 422
    end
  end

  def send_sms
    if sms_params[:partner_ids].empty? && ["pre_active", "active"].include?(params[:status])
      render json: { errors: I18n.t("models.partner.errors.sms.partner_ids") }, status: 404
    end
    SmsPartnersWorker.perform_async(partner_ids: ::Partner.where(id: sms_params[:partner_ids], status: params[:status]).pluck(:id))
    render json: { success: I18n.t("models.partner.response.sms.success") }, status: 201
  end

  private

  def set_partner
    @partner = ::Partner.find_by(id: params[:id])
    head 404 unless @partner
  end

  def sms_params
    params.permit(partner_ids: [])
  end

  def partner_params
    params.permit(:name, :federal_registration, :state_registration,
                  :kind, :status, :started_date, :renewal_date, :description, :origin, :percent, :agency,
                  :ocupation, :account, :favored, :user_id, :bank_id, :discount3, :discount5, :discount8,
                  :cash_redemption, :partner_group_id, :favored_federal_registration)
  end
end
