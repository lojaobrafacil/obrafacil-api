class Api::V1::PricePercentageSerializer < ActiveModel::Serializer
  attributes :id, :margin, :kind, :updated_at, :created_at
end
