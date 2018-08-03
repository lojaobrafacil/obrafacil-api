class Api::V2::ProductsController < Api::V2::Partner::BaseController

  def index
    products = if params['name']
      Product.where("LOWER(name) LIKE LOWER(?)", "%#{params['name']}%")
    else
      Product.all
    end
    paginate json: products.order(:id).as_json(only:[:id, :name, :active, :description]), status: 200
  end

  def show
    product = Product.find(params[:id])
    render json: product, status: 200
  end  
end

