class Partner::SelfsController < Partner::BaseController
  def index
    @partner = current_partner_user.partner
    render json: @partner, status: 200, serializer: Partner::SelfSerializer
  end

  def create
    @partner = Partner.new(partner_params)

    if @partner.save
      render json: { success: "Obrigado por se cadastrar" }, status: 201
    else
      render json: { errors: @partner.errors }, status: 422
    end
  end

  def update_password
    @user = current_partner_user
    @user.update_password(user_password_params[:current_password], user_password_params[:password], user_password_params[:password_confirmation])
    if @user.valid?
      render json: { success: I18n.t("models.user.success.reset_password") }, status: 201
    else
      render json: { errors: @user.errors }, status: 422
    end
  end

  def partner_params
    params.permit(:name, :federal_registration, :state_registration, :agency, :account,
                   :favored, :favored_federal_registration, :bank_id, :ocupation,
                   addresses_attributes: [:street, :number, :complement, :neighborhood, :zipcode,
                                          :description, :address_type_id, :city_id, :_delete],
                   phones: [:id, :phone, :contact, :phone_type_id, :primary, :_delete],
                   emails: [:id, :email, :contact, :email_type_id, :primary, :_delete])
  end

  def user_password_params
    params.permit(:current_password, :password, :password_confirmation)
  end
end
