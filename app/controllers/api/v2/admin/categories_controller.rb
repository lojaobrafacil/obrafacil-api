class Api::V2::Admin::CategoriesController < Api::V2::Admin::BaseController
  def index
    categories = Category.all
    render json: categories.order(:id), status: 200
  end

  def show
    category = Category.find(params[:id])
    render json: category, status: 200
  end

  def create
    category = Category.new(category_params)

    if category.save
      render json: category, status: 201
    else
      render json: { errors: category.errors }, status: 422
    end
  end

  def update
    category = Category.find(params[:id])

    if category.update(category_params)
      render json: category, status: 200
    else
      render json: { errors: category.errors }, status: 422
    end
  end

  def destroy
    category = Category.find(params[:id])
    category.destroy
    head 204
  end

  private

  def category_params
    params.permit(:name)
  end
end
