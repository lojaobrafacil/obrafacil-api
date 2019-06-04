class Api::PartnersController < Api::BaseController
  before_action :authenticate_admin_or_api!
  before_action :set_partner, only: [:show, :update, :destroy, :reset, :reset_password]

  def index
    @partners = policy_scope ::Partner
    begin
      if @partners
        @partners = @partners.where(status: params[:status]) if params[:status] && !params[:status].empty?
        query = []
        query << "LOWER(name) LIKE LOWER('%#{params[:name]}%')" if params[:name] && !params[:name].empty?
        query << "federal_registration LIKE '#{params[:federal_registration]}%'" if params[:federal_registration] && !params[:federal_registration].empty?
        query << "partner_group_id= #{params[:partner_group_id]}" if params[:partner_group_id] && !params[:partner_group_id].empty?
        @partners = params.empty? ? @partners : @partners.where(query.join(" and "))
        paginate json: @partners.order(:name).as_json(only: [:id, :name, :federal_registration, :state_registration, :active, :status, :description, :cash_redemption]), status: 200
      else
        head 404
      end
    rescue => e
      render json: { errors: e }, status: 404
    end
  end

  def show
    render json: @partner, status: 200
  end

  def create
    @partner = ::Partner.new(partner_params)
    @partner.created_by_id = @current_user.id
    if @partner.save
      render json: @partner, status: 201
    else
      render json: { errors: @partner.errors }, status: 422
    end
  end

  def update
    @partner.created_by_id ||= @current_user.id
    if @partner.update(partner_params)
      render json: @partner, status: 200
    else
      render json: { errors: @partner.errors }, status: 422
    end
  end

  def destroy
    authorize @partner
    if @partner.destroy(@current_user.id)
      render json: { success: I18n.t("models.partner.response.delete.success") }, status: 200
    else
      render json: { errors: @partner.errors }, status: 422
    end
  end

  def reset_password
    authorize @partner
    if @partner.reset_password(reset_password_params[:password], reset_password_params[:password_confirmation])
      render json: { success: I18n.t("models.partner.response.reset_password.success") }, status: 200
    else
      render json: { errors: I18n.t("models.partner.response.reset_password.error") }, status: 422
    end
  end

  def send_sms
    if sms_params[:partner_ids].empty?
      render json: { errors: I18n.t("models.partner.errors.sms.partner_ids") }, status: 404
    else
      SmsPartnersWorker.perform_async(partner_ids: sms_params[:partner_ids], status: params[:status])
      render json: { success: I18n.t("models.partner.response.sms.success") }, status: 201
    end
  end

  def by_federal_registration
    @partner = Partner.where(federal_registration: params[:federal_registration]).where.not(status: "deleted").first
    if !@partner || @partner.id == params[:id]&.to_i
      head 404
    else
      render json: @partner, status: 200
    end
  end

  def by_favored_federal_registration
    @partner = Partner.where(favored_federal_registration: params[:favored_federal_registration]).where.not(status: "deleted").first
    if !@partner || @partner.id == params[:id]&.to_i
      head 404
    else
      render json: @partner, status: 200
    end
  end

  private

  def set_partner
    @partner = ::Partner.find_by(id: params[:id])
    head 404 unless @partner
  end

  def sms_params
    params.permit(partner_ids: [])
  end

  def reset_password_params
    params.permit(:password, :password_confirmation)
  end

  def partner_params
    params.permit(:name, :federal_registration, :state_registration,
                  :kind, :status, :started_date, :renewal_date, :description, :origin, :percent,
                  :agency, :ocupation, :account, :favored, :bank_id, :cash_redemption,
                  :partner_group_id, :favored_federal_registration, :site, :register)
  end
end
