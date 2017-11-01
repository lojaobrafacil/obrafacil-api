class Api::V1::RegionsController < ApplicationController

  def index
    regions = Region.all
    render json: {regions: regions}, status: 200
  end

  def create
    region = Region.new(region_params)

    if region.save
      render json: region, status: 201
    else
      render json: { errors: region.errors }, status: 422
    end
  end

  def update
    region = Region.find(params[:id])
    if region.update(region_params)
      render json: region, status: 200
    else
      render json: { errors: region.errors }, status: 422
    end
  end

  def destroy
    region = Region.find(params[:id])
    region.destroy
    head 204
  end

  private

  def region_params
    params.require(:region).permit(:name)
  end
end
