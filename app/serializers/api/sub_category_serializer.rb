class Api::SubCategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :category, :updated_at, :created_at

  def category
    Api::CategorySerializer.new(object.category)
  end
end
