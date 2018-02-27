class Api::V1::IbptsController < Api::V1::BaseController

  def index
    ibpts = Ibpt.all
    paginate json: ibpts.order(:id), status: 200
  end

  def show
    ibpt = Ibpt.find(params[:id])
    render json: ibpt, status: 200
  end

  def create
    ibpt = Ibpt.new(ibpt_params)

    if ibpt.save
      render json: ibpt, status: 201
    else
      render json: { errors: ibpt.errors }, status: 422
    end
  end

  def update
    ibpt = Ibpt.find(params[:id])
    if ibpt.update(ibpt_params)
      render json: ibpt, status: 200
    else
      render json: { errors: ibpt.errors }, status: 422
    end
  end

  def destroy
    ibpt = Ibpt.find(params[:id])
    ibpt.destroy
    head 204
  end

  private

  def ibpt_params
    params.require(:ibpt).permit(:code, :national_aliquota, :international_aliquota)
  end
end
