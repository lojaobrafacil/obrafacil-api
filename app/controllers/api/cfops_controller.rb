class Api::CfopsController < Api::BaseController
  before_action :authenticate_admin_or_api!

  def index
    @cfops = Cfop.all
    paginate json: @cfops.order(:id), status: 200
  end

  def show
    @cfop = Cfop.find_by(id: params[:id])
    if @cfop
      render json: @cfop, status: 200
    else
      head 404
    end
  end

  def create
    @cfop = Cfop.new(cfop_params)

    if @cfop.save
      render json: @cfop, status: 201
    else
      render json: {errors: @cfop.errors}, status: 422
    end
  end

  def update
    @cfop = Cfop.find(params[:id])
    if @cfop.update(cfop_params)
      render json: @cfop, status: 200
    else
      render json: {errors: @cfop.errors}, status: 422
    end
  end

  def destroy
    @cfop = Cfop.find(params[:id])
    @cfop.destroy
    head 204
  end

  private

  def cfop_params
    params.permit(:code, :description)
  end
end
