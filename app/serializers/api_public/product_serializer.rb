class ApiPublic::ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :images
end
