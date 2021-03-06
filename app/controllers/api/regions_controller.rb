class Api::RegionsController < Api::BaseController
  before_action :authenticate_admin_or_api!

  def index
    @regions = policy_scope Region
    paginate json: @regions, status: 200
  end

  def show
    @region = Region.find_by(id: params[:id])
    if @region
      authorize @region
      render json: @region, status: 200
    else
      head 404
    end
  end

  def create
    @region = Region.new(region_params)
    authorize @region
    if @region.save
      render json: @region, status: 201
    else
      render json: {errors: @region.errors}, status: 422
    end
  end

  def update
    @region = Region.find(params[:id])
    authorize @region
    if @region.update(region_params)
      render json: @region, status: 200
    else
      render json: {errors: @region.errors}, status: 422
    end
  end

  def destroy
    @region = Region.find(params[:id])
    authorize @region
    @region.destroy
    head 204
  end

  private

  def region_params
    params.permit(policy(Region).permitted_attributes)
  end
end
