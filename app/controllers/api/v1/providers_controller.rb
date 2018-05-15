class Api::V1::ProvidersController < Api::V1::ContactsController

  def index
    providers = Provider.all
    paginate json: providers.order(:id).as_json(only:[:id, :name, :fantasy_name, :description]), status: 200
  end

  def show
    provider = Provider.find(params[:id])
    render json: provider, status: 200
  end

  def create
    provider = Provider.new(provider_params)

    if provider.save
      update_contact(provider)
      render json: provider, status: 201
    else
      render json: { errors: provider.errors }, status: 422
    end
  end

  def update
    provider = Provider.find(params[:id])
    if provider.update(provider_params)
      update_contact(provider)
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

  private

  def provider_params
    params.require(:provider).permit(:name, :fantasy_name, :federal_tax_number,
      :state_registration, :kind, :birth_date, :tax_regime, :description,
      :billing_type_id, :user_id)
  end
end
