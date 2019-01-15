class Api::CompanyProductsController < Api::ContactsController
  def index
    @company_products = policy_scope CompanyProduct
    paginate json: @company_products
  end

  def show
    @company_product = CompanyProduct.find_by(id: params[:id])
    if @company_product
      authorize @company_product
      render json: @company_product, status: 200
    else
      head 404
    end
  end

  def update
    @company_product = CompanyProduct.find_by(id: params[:id])
    authorize @company_product
    if @company_product.update(company_product_params)
      render json: @company_product, status: 200
    else
      render json: {errors: @company_product.errors}, status: 422
    end
  end

  def update_code_by_product
    @company_product = CompanyProduct.where(product_id: params[:product_id])
    authorize @company_product
    if @company_product.update_all(code: params[:code])
      render json: @company_product, status: 200
    else
      render json: {errors: @company_product.errors}, status: 422
    end
  end

  private

  def company_product_params
    params.permit(policy(CompanyProduct).permitted_attributes)
  end
end
