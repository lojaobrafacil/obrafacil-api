class Api::V1::PricePercentageSerializer < ActiveModel::Serializer
  attributes :id, :margin, :kind
end
