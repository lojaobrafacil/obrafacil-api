class Api::ClientsController < Api::ContactsController
  before_action :authenticate_admin_or_api!
  before_action :set_client, only: [:show, :update, :destroy]

  def index
    @clients = policy_scope Client
    if @clients&.empty? or @clients.nil?
      render json: @clients, status: 200
    else
      @clients = if params[:name] && params[:federal_registration]
                   @clients.where("LOWER(name) LIKE LOWER(?) and federal_registration LIKE ?", "%#{params[:name]}%", "#{params[:federal_registration]}%")
                 else
                   @clients.all
                 end
      paginate json: @clients.order(:id).as_json(only: [:id, :name, :federal_registration, :state_registration, :active, :description]), status: 200
    end
  end

  def show
    authorize @client
    render json: @client, status: 200
  end

  def create
    @client = Client.new(client_params)
    authorize @client
    if @client.save
      update_contact(@client)
      render json: @client, status: 201
    else
      render json: { errors: @client.errors }, status: 422
    end
  end

  def update
    authorize @client
    if @client.update(client_params)
      update_contact(@client)
      render json: @client, status: 200
    else
      render json: { errors: @client.errors }, status: 422
    end
  end

  def destroy
    authorize @client
    if @client.destroy
      render json: { success: I18n.t("models.client.response.delete.success") }, status: 200
    else
      render json: { errors: @client.errors }, status: 422
    end
  end

  private

  def set_client
    @client = Client.find_by(id: params[:id])
    head 404 unless @client
  end

  def client_params
    params.permit(policy(Client).permitted_attributes)
  end
end