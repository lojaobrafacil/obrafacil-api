class ApiPartner::SelfsController < ApiPartner::BaseController
  before_action :authenticate_api_partner_partner!, except: [:create, :by_federal_registration]

  def index
    @partner = current_api_partner_partner
    render json: @partner, status: 200, serializer: Partner::SelfSerializer
  end

  def by_federal_registration
    @partner = Partner.find_by(federal_registration: params[:federal_registration])
    if !@partner
      head 404
    else
      render json: { "CPF / CNPJ": " já esta cadastrado, entre em contato conosco para saber mais t: (11) 3031-6891" }, status: 200
    end
  end

  def create
    if !Partner.find_by(federal_registration: partner_params[:federal_registration].gsub(/[^0-9A-Za-z]/, "").upcase).nil?
      render json: { errors: { "CPF / CNPJ": " já esta cadastrado, entre em contato conosco para saber mais t: (11) 3031-6891" } }, status: 404
    else
      @partner = Partner.new(partner_params)
      @partner.status = "review"
      if @partner.save
        render json: { success: "Obrigado por se cadastrar" }, status: 201
      else
        render json: { errors: @partner.errors }, status: 422
      end
    end
  end

  def update_password
    if current_api_partner_partner.update_password(user_password_params[:current_password], user_password_params[:password], user_password_params[:password_confirmation])
      render json: { success: I18n.t("models.user.success.reset_password") }, status: 201
    else
      render json: { errors: current_api_partner_partner.errors }, status: 422
    end
  end

  def partner_params
    params.permit(:name, :federal_registration, :state_registration, :agency, :account,
                  :favored, :favored_federal_registration, :bank_id, :ocupation, :kind,
                  addresses_attributes: [:street, :number, :complement, :neighborhood, :zipcode,
                                         :description, :address_type_id, :city_id, :_delete],
                  phones_attributes: [:id, :phone, :contact, :phone_type_id, :primary, :_delete],
                  emails_attributes: [:id, :email, :contact, :email_type_id, :primary, :_delete])
  end

  def user_password_params
    params.permit(:current_password, :password, :password_confirmation)
  end
end
