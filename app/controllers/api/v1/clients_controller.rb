class Api::V1::ClientsController < Api::V1::ContactsController

  def index
    clients = Client.all
    paginate json: clients.order(:id), status: 200
  end

  def show
    client = Client.find(params[:id])
    render json: client, status: 200
  end

  def create
    client = Client.new(client_params)

    if client.save
      update_contact(client)
      render json: client, status: 201
    else
      render json: { errors: client.errors }, status: 422
    end
  end

  def update
    client = Client.find(params[:id])
    if client.update(client_params)
      update_contact(client)
      render json: client, status: 200
    else
      render json: { errors: client.errors }, status: 422
    end
  end

  def destroy
    client = Client.find(params[:id])
    client.destroy
    head 204
  end

  private

  def client_params
    params.require(:client).permit(:name, :federal_tax_number, :state_registration,
      :international_registration, :kind, :active, :birth_date, :renewal_date,
      :tax_regime, :description, :order_description, :limit, :billing_type_id, :user_id)
  end
end
