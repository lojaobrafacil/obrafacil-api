class Api::Log::PremioIdealsController < Api::BaseController
  before_action :authenticate_admin_or_api!

  def index
    authorize ::Log::PremioIdeal
    premio_ideals = policy_scope ::Log::PremioIdeal
    if premio_ideals
      paginate json: premio_ideals, status: 200
    else
      head 404
    end
  end

  def show
    premio_ideal = ::Log::PremioIdeal.find(params[:id])
    authorize premio_ideal
    render json: premio_ideal
  end

  def retry
    if ::Log::PremioIdeal.where(id: params[:id]).size > 0
      PremioIdealWorker.perform_async(params[:id], "LOG_RETRY")
      render json: { data: "Running" }, status: 201
    else
      render json: { errors: "Log informado não existe" }, status: 422
    end
  end
end
