class Api::V1::ProvidersController < Api::V1::ContactsController

  def index
    providers = Provider.all
    if providers&.empty? or providers.nil? and Provider.all.size > 0
      render json: providers, status: 401
    else
    providers = if params[:name]
      providers.where("LOWER(name) LIKE LOWER(?) and LOWER(fantasy_name) LIKE LOWER(?)", "%#{params[:name]}%", "#{params[:fantasy_name]}%")
      else
        providers.all
      end
      paginate json: providers.order(:id).as_json(only:[:id, :name, :fantasy_name, :description]), status: 200
    end
  end

  def show
    provider = Provider.find(params[:id])
    render json: provider, status: 200
  end

  def create
    provider = Provider.new(provider_params)

    if provider.save
      update_contact(provider)
      update_user(provider)      
      render json: provider, status: 201
    else
      render json: { errors: provider.errors }, status: 422
    end
  end

  def update
    provider = Provider.find(params[:id])
    if provider.update(provider_params)
      update_contact(provider)
      update_user(provider)      
      render json: provider, status: 200
    else
      render json: { errors: provider.errors }, status: 422
    end
  end

  def destroy
    provider = Provider.find(params[:id])
    provider.destroy
    head 204
  end

  def update_user(provider)
    # if user = User.find_by(federal_registration: provider.federal_tax_number)
    #   if provider.active?
    #     user.update(provider: provider) unless user.provider == provider 
    #   else
    #     user.destroy unless user.provider.active?
    #   end
    # else
    #   email = provider.federal_tax_number? ? provider.federal_tax_number.to_s+"@obrafacil.com" : provider.emails.first.email rescue nil
    #   unless email&.nil?
    #     provider.build_user(email: email,
    #                         federal_registration: provider.federal_tax_number,
    #                         password:"obrafacil2018",
    #                         password_confirmation:"obrafacil2018" ).save
    #   end
    # end
  end

  private

  def provider_params
    params.permit(:name, :fantasy_name, :federal_tax_number,
      :state_registration, :kind, :birth_date, :tax_regime, :description,
      :billing_type_id, :user_id)
  end
end
