class Api::StocksController < Api::BaseController
  before_action :authenticate_admin_or_api!

  def index
    @stocks = policy_scope Stock
    paginate json: @stocks
  end

  def show
    @stock = Stock.find_by(id: params[:id])
    if @stock
      authorize @stock
      render json: @stock, status: 200
    else
      head 404
    end
  end

  def update
    @stock = Stock.find_by(id: params[:id])
    authorize @stock
    if @stock.update(stock_params)
      render json: @stock, status: 200
    else
      render json: { errors: @stock.errors }, status: 422
    end
  end

  def update_code_by_product
    @stock = Stock.where(product_id: params[:product_id])
    authorize @stock
    if @stock.update_all(code: params[:code])
      render json: @stock, status: 200
    else
      render json: { errors: @stock.errors }, status: 422
    end
  end

  private

  def stock_params
    params.permit(policy(Stock).permitted_attributes)
  end
end
