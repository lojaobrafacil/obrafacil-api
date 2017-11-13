class Api::V1::SubCategoriesController < Api::V1::BaseController
  def index
    sub_categories = SubCategory.all
    render json: sub_categories, status: 200
  end

  def show
    sub_category = SubCategory.find(params[:id])
    render json: sub_category, status: 200
  end

  def create
    sub_category = SubCategory.new(sub_category_params)

    if sub_category.save
      render json: sub_category, status: 201
    else
      render json: { errors: sub_category.errors }, status: 422
    end
  end

  def update
    sub_category = SubCategory.find(params[:id])

    if sub_category.update(sub_category_params)
      render json: sub_category, status: 200
    else
      render json: { errors: sub_category.errors }, status: 422
    end
  end

  def destroy
    sub_category = SubCategory.find(params[:id])
    sub_category.destroy
    head 204
  end

  private

  def sub_category_params
    params.require(:sub_category).permit(:name, :category_id)
  end
end
