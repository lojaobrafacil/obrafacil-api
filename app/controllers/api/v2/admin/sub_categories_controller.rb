class Api::V2::Admin::SubCategoriesController < Api::V2::Admin::BaseController
  def index
    sub_categories = params['category_id'] ? Category.find(params['category_id']).sub_categories : SubCategory.all
    paginate json: sub_categories.order(:id), status: 200
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
    if sub_category.products == []
      sub_category.destroy
      head 204
    else
      render json: { errors: "SubCategoria nao pode ser deletada pois possue produtos" }, status: 422      
    end
  end

  private

  def sub_category_params
    params.permit(:name, :category_id)
  end
end
