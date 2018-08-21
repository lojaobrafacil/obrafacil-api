class Api::V2::Admin::RegionsController < Api::V2::Admin::BaseController

  def index
    regions = policy_scope [:admin, Region]
    paginate json: regions, status: 200
  end

  def show
    region = Region.find(params[:id])
    authorize [:admin, region]
    render json: region, status: 200
  end

  def create
    region = Region.new(region_params)
    authorize [:admin, region]
    if region.save
      render json: region, status: 201
    else
      render json: { errors: region.errors }, status: 422
    end
  end

  def update
    region = Region.find(params[:id])
    authorize [:admin, region]
    if region.update(region_params)
      render json: region, status: 200
    else
      render json: { errors: region.errors }, status: 422
    end
  end

  def destroy
    region = Region.find(params[:id])
    authorize [:admin, region]
    region.destroy
    head 204
  end

  private

  def region_params
    params.permit(policy([:admin, Region]).permitted_attributes)
  end
end
