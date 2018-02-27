class Api::V1::CitiesController < Api::V1::BaseController

  def index
    cities = params['state_id'] ? State.find(params['state_id']).cities : City.all
    render json: cities.order(:id), status: 200
  end

  def show
    city = City.find(params[:id])
    render json: city, status: 200
  end

  def create
    city = City.new(city_params)

    if city.save
      render json: city, status: 201
    else
      render json: { errors: city.errors }, status: 422
    end
  end

  def update
    city = City.find(params[:id])
    if city.update(city_params)
      render json: city, status: 200
    else
      render json: { errors: city.errors }, status: 422
    end
  end

  def destroy
    city = City.find(params[:id])
    city.destroy
    head 204
  end

  private

  def city_params
    params.require(:city).permit(:name, :capital, :state_id)
  end
end
