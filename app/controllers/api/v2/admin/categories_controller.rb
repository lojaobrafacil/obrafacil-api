class Api::V2::Admin::CategoriesController < Api::V2::Admin::BaseController
  def index
    categories = policy_scope [:admin, Category]
    render json: categories.order(:id), status: 200
  end

  def show
    category = Category.find(params[:id])
    authorize [:admin, category]
    render json: category, status: 200
  end

  def create
    category = Category.new(category_params)
    authorize [:admin, category]

    if category.save
      render json: category, status: 201
    else
      render json: { errors: category.errors }, status: 422
    end
  end

  def update
    category = Category.find(params[:id])
    authorize [:admin, category]

    if category.update(category_params)
      render json: category, status: 200
    else
      render json: { errors: category.errors }, status: 422
    end
  end

  def destroy
    category = Category.find(params[:id])
    authorize [:admin, category]
    category.destroy
    head 204
  end

  private

  def category_params
    params.permit(policy([:admin, Category]).permitted_attributes)
  end
end
