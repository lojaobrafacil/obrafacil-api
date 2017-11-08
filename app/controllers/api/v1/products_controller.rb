class Api::V1::ProductsController < ApplicationController

  def index
    products = Product.all
    render json: {products: products}, status: 200
  end

  def show
    product = Product.find(params[:id])
    render json: product, status: 200
  end

  def create
    product = Product.new(product_params)

    if product.save
      render json: product, status: 201
    else
      render json: { errors: product.errors }, status: 422
    end
  end

  def update
    product = Product.find(params[:id])
    if product.update(product_params)
      render json: product, status: 200
    else
      render json: { errors: product.errors }, status: 422
    end
  end

  def destroy
    product = Product.find(params[:id])
    product.destroy
    head 204
  end

  private

  def product_params
    params.require(:product).permit( :name, :description, :common_nomenclature_mercosur,
      :added_value_tax, :brand, :cost, :tax_industrialized_products, :profit_margin, :stock,
      :stock_min, :stock_max, :stock_date, :aliquot_merchandise_tax, :bar_code, :tax_substitution,
      :tax_reduction, :discount, :Weight, :Height, :width, :length, :color, :code_tax_substitution_specification,
      :kind, :active, :unit_id, :sub_category_id, :company_id)
  end
end
