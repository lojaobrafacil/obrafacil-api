class Api::V2::UnitsController < Api::V2::BaseController
  def index
    units = Unit.all
    render json: units.order(:id).as_json(only:[:id, :name, :description]), status: 200
  end

  def show
    unit = Unit.find(params[:id])
    render json: unit, status: 200
  end

  def create
    unit = Unit.new(unit_params)

    if unit.save
      render json: unit, status: 201
    else
      render json: { errors: unit.errors }, status: 422
    end
  end

  def update
    unit = Unit.find(params[:id])

    if unit.update(unit_params)
      render json: unit, status: 200
    else
      render json: { errors: unit.errors }, status: 422
    end
  end

  def destroy
    unit = Unit.find(params[:id])
    unit.destroy
    head 204
  end

  private

  def unit_params
    params.permit(:name, :description)
  end
end
