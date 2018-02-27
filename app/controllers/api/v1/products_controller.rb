class Api::V1::ProductsController < Api::V1::BaseController

  def index
    products = if params['name'] and params['brand']
      Product.where("LOWER(name) LIKE LOWER(?)", "%#{params['name']}%")
    else
      Product.all
    end
    paginate json: products.order(:id), status: 200
  end

  def show
    product = Product.find(params[:id])
    render json: product, status: 200
  end

  def create
    product = Product.new(product_params)

    if product.save
      company_product_attributes(product)
      render json: product, status: 201
    else
      render json: { errors: product.errors }, status: 422
    end
  end

  def update
    product = Product.find(params[:id])
    if product.update(product_params)
      company_product_attributes(product)
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
    params.require(:product).permit(:name, :description, :common_nomenclature_mercosur,
      :added_value_tax, :cost, :tax_industrialized_products, :profit_margin,
      :aliquot_merchandise_tax, :bar_code, :tax_substitution, :tax_reduction, :discount,
      :weight, :height, :width, :length, :color, :code_tax_substitution_specification,
      :kind, :active, :unit_id, :sku, :sku_xml, :sub_category_id, :provider_id)
  end

  def company_product_attributes(product)
    unless params[:company_products].nil?
      params.require(:company_products).each do |company_product|
        p company_product
        cp = company_product.permit(:id, :stock, :stock_max, :company_id, :stock_min, :_destroy)
        if cp[:id] != nil
          if cp[:_destroy] == true
            CompanyProduct.find(cp[:id]).delete
          else
            CompanyProduct.find(cp[:id]).update!(cp)
          end
        else
          p "Product.company_products.create!(cp)"
          product.company_products.create!(cp)
        end
      end
    end
  end
end
