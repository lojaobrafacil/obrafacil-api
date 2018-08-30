class Api::V2::Admin::ClientsController < Api::V2::Admin::ContactsController

  def index
    clients = policy_scope [:admin, Client]
    if clients&.empty? or clients.nil? or clients.all.size < 1
      render json: clients, status: 401
    else
      clients = if params[:name] && params[:federal_registration] 
        clients.where("LOWER(name) LIKE LOWER(?) and federal_registration LIKE ?", "%#{params[:name]}%", "#{params[:federal_registration]}%")
        else
          clients.all
        end
      paginate json: clients.order(:id).as_json(only: [:id, :name,:federal_registration, :state_registration, :active, :description]), status: 200
    end
  end

  def show
    client = Client.find(params[:id])
    authorize [:admin, client]
    render json: client, status: 200
  end

  def create
    client = Client.new(client_params)
    authorize [:admin, client]
    if client.save
      update_contact(client)
      render json: client, status: 201
    else
      render json: { errors: client.errors }, status: 422
    end
  end

  def update
    client = Client.find(params[:id])
    authorize [:admin, client]
    if client.update(client_params)
      update_contact(client)
      render json: client, status: 200
    else
      render json: { errors: client.errors }, status: 422
    end
  end

  def destroy
    client = Client.find(params[:id])
    authorize [:admin, client]
    user = client.user
    client.destroy
    user.destroy if user.partner
    head 204
  end

  private

  def client_params
    params.permit(policy([:admin, Client]).permitted_attributes)
  end
end
