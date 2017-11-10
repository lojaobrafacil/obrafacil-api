class Api::V1::PriceSerializer < ActiveModel::Serializer
  attributes :id, :price, :margin, :kind, :product
end
