class Api::V1::ProvidersController < Api::V1::ContactsController

  def index
    providers = Provider.all
    paginate json: providers, status: 200
  end

  def show
    provider = Provider.find(params[:id])
    render json: provider, status: 200
  end

  def create
    provider = Provider.new(provider_params)

    if provider.save && provider.addresses.build(addresses_params[:addresses_attributes]) && provider.phones.build(phones_params[:phones_attributes]) && provider.emails.build(emails_params[:emails_attributes])
      render json: provider, status: 201
    else
      render json: { errors: provider.errors }, status: 422
    end
  end

  def update
    provider = Provider.find(params[:id])
    if provider.update(provider_params) && provider.addresses.build(addresses_params[:addresses_attributes]) && provider.phones.build(phones_params[:phones_attributes]) && provider.emails.build(emails_params[:emails_attributes])
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
      :invoice_sale, :invoice_return, :pis_percent, :confins_percent,
      :icmsn_percent, :between_states_percent, :billing_type_id, :user_id)
  end
end
