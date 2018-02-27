class Api::V1::SubCategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :category, :updated_at, :created_at
end
