class Partner::SelfsController < Partner::BaseController
  def index
    @partner = current_partner_user.partner
    render json: @partner, status: 200, serializer: Partner::SelfSerializer
  end

  def create
    @partner = Partner.new(partner_params)

    if @partner.save
      render json: {success: "Obrigado por se cadastrar"}, status: 201
    else
      render json: { errors: @partner.errors }, status: 422
    end
  end

  def partner_params
    partner.permit(:name, :federal_registration, :state_registration, :agency, :account,
                   :favored, :favored_federal_registration, :bank_id, :ocupation,
                   addresses_attributes: [:street, :number, :complement, :neighborhood, :zipcode,
                                          :description, :address_type_id, :city_id, :_delete],
                   phones: [:id, :phone, :contact, :phone_type_id, :primary, :_delete],
                   emails: [:id, :email, :contact, :email_type_id, :primary, :_delete])
  end
end
