class Api::V1::CfopsController < Api::V1::BaseController

  def index
    cfops = Cfop.all
    render json: cfops, status: 200
  end

  def show
    cfop = Cfop.find(params[:id])
    render json: cfop, status: 200
  end

  def create
    cfop = Cfop.new(cfop_params)

    if cfop.save
      render json: cfop, status: 201
    else
      render json: { errors: cfop.errors }, status: 422
    end
  end

  def update
    cfop = Cfop.find(params[:id])
    if cfop.update(cfop_params)
      render json: cfop, status: 200
    else
      render json: { errors: cfop.errors }, status: 422
    end
  end

  def destroy
    cfop = Cfop.find(params[:id])
    cfop.destroy
    head 204
  end

  private

  def cfop_params
    params.require(:cfop).permit(:code, :description)
  end
end
