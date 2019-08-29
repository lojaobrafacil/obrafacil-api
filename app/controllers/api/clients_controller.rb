class Api::ClientsController < Api::ContactsController
  before_action :authenticate_admin_or_api!
  before_action :set_client, only: [:show, :update, :destroy]

  def index
    @clients = policy_scope ::Client
    begin
      if @clients
        @clients = @clients.where(status: params[:status]) if params[:status] && !params[:status].empty?
        query = []
        query << "LOWER(name) LIKE LOWER('%#{params[:name]}%')" if params[:name] && !params[:name].empty?
        query << "federal_registration LIKE '#{params[:federal_registration]}%'" if params[:federal_registration] && !params[:federal_registration].empty?
        @clients = params.empty? ? @clients : @clients.where(query.join(" and "))
        paginate json: @clients.order(:id), status: 200, each_serializer: Api::ClientsSerializer
      else
        head 404
      end
    rescue => e
      render json: { errors: e }, status: 404
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
