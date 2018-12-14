class Api::VehiclesController < Api::BaseController
  def index 
    @vehicles = Vehicle.all
    paginate json: @vehicles.order(:id), status: 200
  end

  def show
    @vehicle = Vehicle.find_by(id: params[:id])
    if @vehicle
      render json: @vehicle, status: 200
    else
      head 404
    end
  end

  def create
    @vehicle = Vehicle.new(vehicle_params)
      if @vehicle.save
        render json: @vehicle, status: 201
      else
        render json: { errors: @vehicle.errors }, status: 422
      end
  end

  def update
      @vehicle = Vehicle.find(params[:id])
      if @vehicle.update(vehicle_params)
        render json: @vehicle, status: 200
      else
        render json: { errors: @vehicle.errors }, status: 422
      end
  end

  def destroy
    @vehicle = Vehicle.find(params[:id])
    @vehicle.destroy
    head 204
  end

  private
  
  def vehicle_params
    params.permit(:model, :brand)
  end
end
