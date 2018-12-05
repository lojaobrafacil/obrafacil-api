class Api::ApisController < Api::BaseController

  # before_action :authenticate_admin_or_api!

  def index
    @apis = Api.all #policy_scope Api
    paginate json: @apis.order(:id).as_json(only: [:id, :name, :federal_registration, :active]), status: 200
  end

  def show
    @api = Api.find(params[:id])
    authorize @api
    render json: @api, status: 200
  end

  def create
    @api = Api.new(api_params)
    authorize @api
    if @api.save
      render json: @api, status: 201
    else
      render json: { errors: @api.errors }, status: 422
    end
  end

  def update
    @api = Api.find(params[:id])
    authorize @api
    if @api.update(api_params)
      render json: @api, status: 200
    else
      render json: { errors: @api.errors }, status: 422
    end
  end

  def destroy
    @api = Api.find(params[:id])
    authorize @api
    @api.destroy
    head 204
  end

  private

  def api_params
    params.permit(policy(Api).permitted_attributes)    
  end
end