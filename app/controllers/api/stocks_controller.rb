class Api::StocksController < Api::ContactsController

  def index
    @company_products = policy_scope CompanyProducts
    paginate json: @company_products
  end

  def show
    @company_products = CompanyProducts.find_by(id: params[:id])
    authorize company_products
    render json: company, status: 200
  end

  def update
    @company_products = CompanyProducts.find_by(id: params[:id])
    authorize company_products
    if @company_products.update(company_params)
      render json: @company_products, status: 200
    else
      render json: { errors: @company_products.errors }, status: 422
    end
  end

  def update_code_by_product
    @company_products = CompanyProducts.where(product_id: params[:product_id])
    authorize company_products
    if @company_products.update_all(code: params[:code])
      render json: @company_products, status: 200
    else
      render json: { errors: @company_products.errors }, status: 422
    end
  end

  private

  def company_params
    params.permit(policy(CompanyProducts).permitted_attributes)
  end
end
