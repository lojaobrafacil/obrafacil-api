class ApiPublic::ProductsController < ApplicationController
  def show
    @product = Product.find_by(id: params[:id])
    render json: @product, status: 200, serializer: ApiPublic::ProductSerializer
  end
end
