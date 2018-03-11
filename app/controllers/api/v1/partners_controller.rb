class Api::V1::PartnersController < Api::V1::ContactsController

  def index
    partners = if params['name']
      Partner.where("LOWER(name) LIKE LOWER(?)", "%#{params['name']}%")
    else
      Partner.all
    end
    paginate json: partners.order(:name), status: 200
  end

  def show
    partner = Partner.find(params[:id])
    render json: partner, status: 200
  end

  def create
    partner = Partner.new(partner_params)
    
    if partner.save
      update_contact(partner)
      if user = User.find_by(federal_registration: partner.federal_tax_number)
        user.update(partner: partner) unless user.partner == partner
      else
        partner.build_user(email: partner.emails.first.email, 
                            federal_registration: partner.federal_tax_number, 
                            password:"primeirologin", 
                            password_confirmation:"primeirologin" )
      end
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
      :kind, :active, :started_date, :renewal_date, :description, :origin, :percent, :agency, 
      :ocupation, :account, :favored, :user_id, :bank_id)
  end
end
