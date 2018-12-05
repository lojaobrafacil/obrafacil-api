class Api::V2::Admin::CitiesController < Api::BaseController

  def index
    cities = policy_scope [:admin, City]
    cities = params['state_id'] ? cities.where("state_id = ?", params['state_id']) : cities.all
    render json: cities.order(:id).as_json(only: [:id, :name]), status: 200
  end

  def show
    city = City.find(params[:id])
    authorize [:admin, city]
    render json: city, status: 200
  end

  def create
    city = City.new(city_params)
    authorize [:admin, city]
    if city.save
      render json: city, status: 201
    else
      render json: { errors: city.errors }, status: 422
    end
  end

  def update
    city = City.find(params[:id])
    authorize [:admin, city]
    if city.update(city_params)
      render json: city, status: 200
    else
      render json: { errors: city.errors }, status: 422
    end
  end

  def destroy
    city = City.find(params[:id])
    authorize [:admin, city]
    city.destroy
    head 204
  end

  private

  def city_params
    params.permit(policy([:admin, City]).permitted_attributes)
  end
end
