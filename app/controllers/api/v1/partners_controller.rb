class Api::V1::PartnersController < Api::V1::ContactsController

  def index
    partners = Partner.all
    paginate json: partners, status: 200
  end

  def show
    partner = Partner.find(params[:id])
    render json: partner, status: 200
  end

  def create
    partner = Partner.new(partner_params)

    if partner.save && partner.addresses.create(addresses_params[:addresses_attributes]) && partner.phones.create(phones_params[:phones_attributes]) && partner.emails.create(emails_params[:emails_attributes])
      render json: partner, status: 201
    else
      render json: { errors: partner.errors }, status: 422
    end
  end

  def update
    partner = Partner.find(params[:id])

    # addresses_params[:addresses_attributes].first["id"] ? partner.addresses.find(addresses_params[:addresses_attributes].first["id"]).update(addresses_params[:addresses_attributes].first.except(:id)) : partner.addresses.create(addresses_params[:addresses_attributes]) if addresses_params[:addresses_attributes]
    # phones_params[:phones_attributes].first["id"] ? partner.phones.find(phones_params[:phones_attributes].first["id"]).update(phones_params[:phones_attributes].first.except(:id)) : partner.phones.create(phones_params[:phones_attributes]) if phones_params[:phones_attributes]
    # emails_params[:emails_attributes].first["id"] ? partner.emails.find(emails_params[:emails_attributes].first["id"]).update(emails_params[:emails_attributes].first.except(:id)) : partner.emails.create(emails_params[:emails_attributes]) if emails_params[:emails_attributes]

    if partner.update(partner_params) && partner.addresses.create(addresses_params[:addresses_attributes]) && partner.phones.create(phones_params[:phones_attributes]) && partner.emails.create(emails_params[:emails_attributes])
      render json: partner, status: 200
    else
      render json: { errors: partner.errors }, status: 422
    end
  end

  def destroy
    partner = Partner.find(params[:id])
    partner.destroy
    head 204
  end

  private

  def partner_params
    params.require(:partner).permit(:name, :federal_tax_number, :state_registration,
      :international_registration, :kind, :active, :birth_date, :renewal_date, :tax_regime,
      :description, :order_description, :limit, :origin, :percent, :agency, :account,
      :favored, :billing_type_id, :user_id, :bank_id)
  end
end
