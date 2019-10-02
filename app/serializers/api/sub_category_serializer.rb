class Api::SubCategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :category, :category_id, :updated_at, :created_at

  def category
    Api::CategorySerializer.new(object.category)
  end
end
