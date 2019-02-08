class Api::UnitsController < Api::BaseController
  before_action :set_unit, only: [:show, :update, :destroy]
  before_action :authenticate_admin_or_api!

  def index
    @units = policy_scope Unit
    render json: @units.order(:id).as_json(only: [:id, :name, :description]), status: 200
  end

  def show
    authorize @unit
    render json: @unit, status: 200
  end

  def create
    @unit = Unit.new(unit_params)
    authorize @unit
    if @unit.save
      render json: @unit, status: 201
    else
      render json: {errors: @unit.errors}, status: 422
    end
  end

  def update
    authorize @unit
    if @unit.update(unit_params)
      render json: @unit, status: 200
    else
      render json: {errors: @unit.errors}, status: 422
    end
  end

  def destroy
    authorize @unit
    @unit.destroy
    head 204
  end

  private

  def set_unit
    @unit = Unit.find_by(id: params[:id])
    head 404 unless @unit
  end

  def unit_params
    params.permit(policy(Unit).permitted_attributes)
  end
end
