class Api::V2::Admin::UnitsController < Api::V2::Admin::BaseController
  def index
    units = policy_scope [:admin, Unit]
    render json: units.order(:id).as_json(only:[:id, :name, :description]), status: 200
  end

  def show
    unit = Unit.find(params[:id])
    render json: unit, status: 200
  end

  def create
    unit = Unit.new(unit_params)
    authorize [:admin, unit]
    if unit.save
      render json: unit, status: 201
    else
      render json: { errors: unit.errors }, status: 422
    end
  end

  def update
    unit = Unit.find(params[:id])
    authorize [:admin, unit]
    if unit.update(unit_params)
      render json: unit, status: 200
    else
      render json: { errors: unit.errors }, status: 422
    end
  end

  def destroy
    unit = Unit.find(params[:id])
    authorize [:admin, unit]
    unit.destroy
    head 204
  end

  private

  def unit_params
    params.permit(policy([:admin, Product]).permitted_attributes)
  end
end
