class Api::V2::Admin::Log::PremioIdealsController < Api::V2::Admin::BaseController

  def index
    premio_ideals = policy_scope [:admin, ::Log::PremioIdeal]

    render json: premio_ideals.order(:updated_at)
  end

  def show
    premio_ideal = ::Log::PremioIdeal.find(params[:id])
    authorize [:admin, premio_ideal]
    render json: premio_ideal
  end

  def retry
    if ::Log::PremioIdeal.where(id: params[:id]).size > 0
      PremioIdealWorker.perform_async(params[:id], "LOG_RETRY")
      render json: {data: "Running"}, status: 201
    else
      render json: {errors: "Log informado não existe"}, status: 422
    end
  end
end
