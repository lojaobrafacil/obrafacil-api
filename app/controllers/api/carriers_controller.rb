class Api::CarriersController < Api::BaseController
  before_action :authenticate_admin_or_api!

  def index
    @carriers = policy_scope Carrier
    begin
      if @carriers
        paginate json: @carriers.order(:id), status: 200
      else
        head 404
      end
    rescue => e
      render json: { errors: e }, status: 404
    end
  end

  def show
    @carrier = Carrier.find_by(id: params[:id])
    if @carrier
      authorize @carrier
      render json: @carrier, status: 200
    else
      head 404
    end
  end

  def create
    @carrier = Carrier.new(carrier_params)
    authorize @carrier
    if @carrier.save
      render json: @carrier, status: 201
    else
      render json: { errors: @carrier.errors }, status: 422
    end
  end

  def update
    @carrier = Carrier.find(params[:id])
    authorize @carrier
    if @carrier.update(carrier_params)
      render json: @carrier, status: 200
    else
      render json: { errors: @carrier.errors }, status: 422
    end
  end

  def destroy
    @carrier = Carrier.find(params[:id])
    authorize @carrier
    @carrier.destroy
    head 204
  end

  private

  def carrier_params
    params.permit(policy(Carrier).permitted_attributes)
  end
end
