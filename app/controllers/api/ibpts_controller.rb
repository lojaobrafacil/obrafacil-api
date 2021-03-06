class Api::IbptsController < Api::BaseController
  before_action :authenticate_admin_or_api!

  def index
    @ibpts = Ibpt.all
    paginate json: @ibpts.order(:id), status: 200
  end

  def show
    @ibpt = Ibpt.find_by(id: params[:id])
    if @ibpt
      render json: @ibpt, status: 200
    else
      head 404
    end
  end

  def create
    @ibpt = Ibpt.new(ibpt_params)

    if @ibpt.save
      render json: @ibpt, status: 201
    else
      render json: {errors: @ibpt.errors}, status: 422
    end
  end

  def update
    @ibpt = Ibpt.find(params[:id])
    if @ibpt.update(ibpt_params)
      render json: @ibpt, status: 200
    else
      render json: {errors: @ibpt.errors}, status: 422
    end
  end

  def destroy
    @ibpt = Ibpt.find(params[:id])
    @ibpt.destroy
    head 204
  end

  private

  def ibpt_params
    params.permit(:code, :national_aliquota, :international_aliquota)
  end
end
