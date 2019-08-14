class ApiPartner::SelfsController < ApiPartner::BaseController
  before_action :authenticate_api_partner_partner!, except: [:create, :by_federal_registration, :reset_by_federal_registration, :indication]

  def index
    @partner = current_api_partner_partner
    render json: @partner, status: 200, serializer: ApiPartner::SelfSerializer
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
    if !partner_params[:federal_registration].to_s.empty? && !Partner.find_by(federal_registration: partner_params[:federal_registration].gsub(/[^0-9A-Za-z]/, "").upcase).nil?
      render json: { errors: { "CPF / CNPJ": " já esta cadastrado, entre em contato conosco para saber mais t: (11) 3031-6891" } }, status: 404
    else
      @partner = Partner.new(partner_params)
      @partner.status = "review"
      if @partner.save
        PartnerMailer.new_partner(@partner).deliver_now rescue nil
      end
      render json: { success: "Recebemos sua solicitação, aguarde a validação do cadastro" }, status: 201
    end
  end

  def upload_image
    if @partner.update(partner_image_params)
      render json: @partner, status: 200
    else
      render json: { errors: @partner.errors }, status: 422
    end
  end

  def indication
    if Email.find_by(email: indication_params[:email].strip).nil?
      @partner = Partner.new({ name: indication_params[:partner_name],
                               site: indication_params[:site],
                               kind: 0,
                               status: "pre_active",
                               phones_attributes: [{ phone: indication_params[:phone], phone_type_id: 4, primary: true }],
                               emails_attributes: [{ email: indication_params[:email], email_type_id: 4, primary: true }],
                               description: "Indicação do cliente: #{indication_params[:client_name]}" })

      if @partner.save
        PartnerMailer.new_indication(@partner).deliver_now rescue nil
      end
    end
    render json: { success: "Obrigado por sua indicação" }, status: 201
  end

  def update_password
    if current_api_partner_partner.update_password(user_password_params[:current_password], user_password_params[:password], user_password_params[:password_confirmation])
      render json: { success: I18n.t("models.user.success.reset_password") }, status: 201
    else
      render json: { errors: current_api_partner_partner.errors }, status: 422
    end
  end

  private

  def partner_params
    params.permit(:name, :federal_registration, :state_registration, :agency, :account,
                  :favored, :favored_federal_registration, :bank_id, :ocupation, :kind,
                  :site, :register, :avatar, :project_image, :instagram, :aboutme,
                  addresses_attributes: [:street, :number, :complement, :neighborhood, :zipcode,
                                         :description, :address_type_id, :city_id, :_delete],
                  phones_attributes: [:id, :phone, :contact, :phone_type_id, :primary, :_delete],
                  emails_attributes: [:id, :email, :contact, :email_type_id, :primary, :_delete])
  end

  def indication_params
    params.permit(:client_name, :partner_name, :email, :phone, :site)
  end

  def user_password_params
    params.permit(:current_password, :password, :password_confirmation)
  end
end
