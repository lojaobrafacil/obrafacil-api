class Api::SubCategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :category_id, :category_name, :updated_at, :created_at

  def category_name
    object.category.name
  end
end
