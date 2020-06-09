class Api::CitiesController < Api::BaseController
  before_action :authenticate_admin_or_api!

  def index
    @cities = policy_scope City
    query = []
    query << "LOWER(searcher) ILIKE LOWER('%#{params[:search]}%')" if params[:search] && !params[:search].empty?
    query << "state_id = '#{params[:state_id]}'" if params[:state_id] && !params[:state_id].empty?
    @cities = @cities.where(query.join("and"))
    render json: @cities.order(:id).as_json(only: [:id, :name, :searcher]), status: 200
  end

  def show
    @city = City.find_by(id: params[:id])
    if @city
      authorize @city
      render json: @city, status: 200
    else
      head 404
    end
  end

  def create
    @city = City.new(city_params)
    authorize @city
    if @city.save
      render json: @city, status: 201
    else
      render json: { errors: @city.errors }, status: 422
    end
  end

  def update
    @city = City.find(params[:id])
    authorize @city
    if @city.update(city_params)
      render json: @city, status: 200
    else
      render json: { errors: @city.errors }, status: 422
    end
  end

  def destroy
    @city = City.find(params[:id])
    authorize @city
    @city.destroy
    head 204
  end

  private

  def city_params
    params.permit(policy(City).permitted_attributes)
  end
end
