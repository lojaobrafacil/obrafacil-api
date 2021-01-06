class Api::ProductsController < Api::BaseController
  before_action :set_product, only: [:show, :update, :destroy]
  before_action :authenticate_admin_or_api!

  def index
    @products = Product.all
    @products = if params["name"]
        @products.where("LOWER(name) LIKE LOWER(?)", "%#{params["name"]}%")
      else
        @products.all
      end
    paginate json: @products.order(:id), status: 200, each_serializer: Api::ProductSerializer
  end

  def show
    authorize @product
    render json: @product, status: 200
  end

  def create
    @product = Product.new(product_params)
    authorize @product
    if @product.save
      render json: @product, status: 201
    else
      render json: { errors: @product.errors.full_messages }, status: 422
    end
  end

  def update
    authorize @product
    if @product.update(product_params)
      render json: @product, status: 200
    else
      render json: { errors: @product.errors.full_messages }, status: 422
    end
  end

  def destroy
    authorize @product
    @product.destroy
    head 204
  end

  private

  def set_product
    @product = Product.find_by(id: params[:id])
    head 404 unless @product
  end

  def product_params
    params.permit(policy(Product).permitted_attributes)
  end
end
