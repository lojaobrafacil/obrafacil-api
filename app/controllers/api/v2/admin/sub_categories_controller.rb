class Api::V2::Admin::SubCategoriesController < Api::V2::Admin::BaseController
  def index
    sub_categories = policy_scope [:admin, SubCategory]
    sub_categories = params['category_id'] ? SubCategory.where(category_id: params['category_id']) : sub_categories
    paginate json: sub_categories.order(:id), status: 200
  end

  def show
    sub_category = SubCategory.find(params[:id])
    authorize [:admin, SubCategory]
    render json: sub_category, status: 200
  end

  def create
    sub_category = SubCategory.new(sub_category_params)
    authorize [:admin, SubCategory]

    if sub_category.save
      render json: sub_category, status: 201
    else
      render json: { errors: sub_category.errors }, status: 422
    end
  end

  def update
    sub_category = SubCategory.find(params[:id])
    authorize [:admin, SubCategory]

    if sub_category.update(sub_category_params)
      render json: sub_category, status: 200
    else
      render json: { errors: sub_category.errors }, status: 422
    end
  end

  def destroy
    sub_category = SubCategory.find(params[:id])
    authorize [:admin, SubCategory]
    if sub_category.products == []
      sub_category.destroy
      head 204
    else
      render json: { errors: "Sub Categoria não pode ser deletada pois possue produtos" }, status: 422      
    end
  end

  private

  def sub_category_params
    params.permit(policy([:admin, SubCategory]).permitted_attributes)    
  end
end
