class Api::V2::Admin::PartnersController < Api::V2::Admin::ContactsController

  def index
    partners = policy_scope [:admin, ::Partner]
    if partners&.empty? or partners.nil?
      render json: partners, status: 401
    else
      partners = if params[:name] && params[:federal_registration] 
        partners.where("LOWER(name) LIKE LOWER(?) and federal_registration LIKE ?", "%#{params[:name]}%", "#{params[:federal_registration]}%")
        else
          partners.all
        end
      paginate json: partners.order(:name).as_json(only: [:id, :name,:federal_registration, :state_registration, :active, :description, :cash_redemption]), status: 200
    end
  end

  def show
    partner = ::Partner.find(params[:id])
    authorize [:admin, partner]
    render json: partner, status: 200
  end

  def create
    partner = ::Partner.new(partner_params)
    authorize [:admin, partner]
    if partner.save
      update_contact(partner)
      PremioIdealWorker.perform_async(partner.id.to_s)      
      render json: partner, status: 201
    else
      render json: { errors: partner.errors }, status: 422
    end
  end

  def update
    partner = ::Partner.find(params[:id])
    authorize [:admin, partner]
    fdr_old = partner.federal_registration
    fdr_new = partner_params['federal_registration']
    if partner.update(partner_params)
      update_contact(partner)
      PremioIdealWorker.perform_async(partner.id.to_s)      
      render json: partner, status: 200
    else
      render json: { errors: partner.errors }, status: 422
    end
  end

  def destroy
    partner = ::Partner.find(params[:id])
    authorize [:admin, partner]
    user = partner.user
    partner.destroy
    user.destroy if !user.client
    head 204
  end

  private

  def partner_params
    params.permit(policy([:admin, ::Partner]).permitted_attributes)
  end
  
end
