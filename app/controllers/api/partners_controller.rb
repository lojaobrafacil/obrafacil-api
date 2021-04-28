class Api::PartnersController < Api::BaseController
  before_action :authenticate_admin_or_api!
  before_action :set_partner, only: [:show, :update, :destroy, :reset, :reset_password]

  def index
    @partners = policy_scope ::Partner
    filparams = filtered_params
    if !filparams.empty?
      query = []
      query << "LOWER(searcher) ILIKE LOWER('%#{filparams[:searcher]}%')" if filparams[:searcher] && !filparams[:searcher].empty?
      query << "status in (#{Partner.statuses.filter { |i, e| filparams[:status].split(",").include?(i) }.values.join(",")})" if filparams[:status] && !filparams[:status].empty? && filparams[:status].split(",").filter { |i| Partner.statuses.include?(i) }
      query << "id in (#{filparams[:ids]})" if filparams[:ids] && !filparams[:ids].empty? && filparams[:ids].chomp(",").match?(/^\d+(,\d+)*$/)
      query << "LOWER(name) LIKE LOWER('%#{filparams[:name]}%')" if filparams[:name] && !filparams[:name].empty?
      query << "federal_registration LIKE '#{filparams[:federal_registration]}%'" if filparams[:federal_registration] && !filparams[:federal_registration].empty?
      query << "partner_group_id= #{filparams[:partner_group_id]}" if filparams[:partner_group_id] && !filparams[:partner_group_id].empty?
      query = query.join(" and ")
    end
    @partners = filparams[:searcher] ? @partners.where(query).order("position(LOWER('#{filparams[:searcher]}') in lower(searcher)), id, name") : filparams[:order_by] ? @partners.where(query).order(filparams[:order_by]) : @partners.where(query).order(:name)
    paginate json: @partners, status: 200, each_serializer: Api::PartnersSerializer
  end

  def show
    if @current_user.is_a?(Employee) && !(@current_user.admin || @current_user.change_partners)
      return render json: @partner, status: 200, serializer: Api::PartnerSerializer
    end
    render json: @partner, status: 200, serializer: Api::PartnerFullSerializer
  end

  def create
    @partner = ::Partner.new(partner_params)
    @partner.created_by_id = @current_user.id
    if @partner.save
      render json: @partner, status: 201
    else
      render json: { errors: @partner.errors.full_messages }, status: 422
    end
  end

  def update
    @partner.created_by_id ||= @current_user.id
    if @partner.update(partner_params)
      render json: @partner, status: 200
    else
      render json: { errors: @partner.errors.full_messages }, status: 422
    end
  end

  def destroy
    authorize @partner
    if @partner.destroy(@current_user.id)
      render json: { success: I18n.t("models.partner.response.delete.success") }, status: 200
    else
      render json: { errors: @partner.errors.full_messages }, status: 422
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

  def upload_image
    if @partner.update(partner_image_params)
      render json: @partner, status: 200
    else
      render json: { errors: @partner.errors.full_messages }, status: 422
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
                  :kind, :status, :birthday, :renewal_date, :description, :origin, :percent,
                  :agency, :ocupation, :account, :favored, :bank_id, :cash_redemption,
                  :partner_group_id, :favored_federal_registration, :site, :register,
                  :avatar, :project_image, :instagram, :aboutme, :can_published,
                  addresses_attributes: [:id, :street, :number, :complement, :neighborhood, :zipcode,
                                         :description, :address_type_id, :city_id, :_destroy],
                  phones_attributes: [:id, :phone, :contact, :phone_type_id, :primary, :_destroy],
                  emails_attributes: [:id, :email, :contact, :email_type_id, :primary, :_destroy])
  end

  def partner_image_params
    params.permit(:avatar, :image)
  end

  def filtered_params
    params.permit(:searcher, :status, :ids, :name, :federal_registration, :partner_group_id, :order_by)
  end
end
