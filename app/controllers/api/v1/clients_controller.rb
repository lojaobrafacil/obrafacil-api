class Api::V1::ClientsController < Api::V1::ContactsController

  def index
    clients = Client.all
    if clients&.empty? or clients.nil? and Client.all.size > 0
      render json: clients, status: 401
    else
      clients = if params[:name] && params[:federal_tax_number] 
        clients.where("LOWER(name) LIKE LOWER(?) and federal_tax_number LIKE ?", "%#{params[:name]}%", "#{params[:federal_tax_number]}%")
        else
          clients.all
        end
      paginate json: clients.order(:id).as_json(only: [:id, :name,:federal_tax_number, :state_registration, :active]), status: 200
    end
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
    params.permit(:name, :federal_tax_number, :state_registration,
      :international_registration, :kind, :active, :birth_date, :renewal_date,
      :tax_regime, :description, :order_description, :limit, :billing_type_id, :user_id)
  end
end
