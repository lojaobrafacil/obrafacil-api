class Api::V1::PartnersController < Api::V1::ContactsController

  def index
    partners = Partner.all
    paginate json: partners.order(:id), status: 200
  end

  def show
    partner = Partner.find(params[:id])
    render json: partner, status: 200
  end

  def create
    partner = Partner.new(partner_params)

    if partner.save
      update_contact(partner)
      render json: partner, status: 201
    else
      render json: { errors: partner.errors }, status: 422
    end
  end

  def update
    partner = Partner.find(params[:id])

    if partner.update(partner_params)
      update_contact(partner)
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
    params.require(:partner).permit(:id, :name, :federal_tax_number, :state_registration, 
      :kind, :active, :birth_date, :renewal_date, :description, :order_description,
      :origin, :percent, :agency, :account, :favored, :billing_type_id, :user_id, :bank_id)
  end
end
