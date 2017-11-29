class Api::V1::PartnersController < Api::V1::BaseController

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

    if partner.save
      render json: partner, status: 201
    else
      render json: { errors: partner.errors }, status: 422
    end
  end

  def update
    partner = Partner.find(params[:id])
    if partner.update(partner_params)
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
      :favored, :billing_type_id, :user_id, :bank_id, 
      :addresses_attributes => [:id, :street, :neighborhood, :zipcode, :ibge, :gia, :complement, :description, :address_type_id, :city_id, :_destroy],
      :phones_attributes => [:id, :phone, :phone_type_id, :_destroy],
      :emails_attributes => [:id, :email, :email_type_id, :_destroy]) 
  end
end
