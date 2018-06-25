class Api::V1::ProductsController < Api::V1::BaseController

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

  def create
    product = Product.new(product_params)

    if product.save
      company_product_attributes(product) if params[:company_products]
      image_products_attributes(product) if params[:images]
      byebug
      render json: product, status: 201
    else
      render json: { errors: product.errors }, status: 422
    end
  end

  def update
    product = Product.find(params[:id])
    if product.update(product_params)
      company_product_attributes(product) if params[:company_products]
      image_products_attributes(product) if params[:images]
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
    params.permit(:name, :description, :ncm, :icms, :ipi, :cest, 
      :bar_code, :reduction, :weight, :height, :width, :length, :provider_id,
      :kind, :active, :unit_id, :sku, :sku_xml, :sub_category_id)
  end

  def company_product_attributes(product)
    company_products_params.each do |cp|
      cps = cp.permit(:id, :stock, :stock_max, :company_id, :stock_min, :cost, :discount, :st, :margin, :_destroy)
      if cps[:id] != nil 
        cps[:_destroy] ? CompanyProduct.find(cps[:id]).delete : CompanyProduct.find(cps[:id]).update!(cps)
      else
        begin
          product.company_products.create!(cps)
        rescue 
          nil
        end
      end
    end
  end 
  
  def image_products_attributes(product)
    image_products_params.each do |image|
      image = image.permit(:id, :attachment)
      if image[:id] != nil 
        image[:_destroy] ? ImageProduct.find(image[:id]).destroy : ImageProduct.find(image[:id]).update!(image)
      else
        begin
          product.image_products.create!(image)
        rescue 
          nil
        end
      end
    end
  end

  def image_products_params
    params[:images]
  end

  def company_products_params
    params[:company_products]
  end
end
