class Api::V1::UnitSerializer < ActiveModel::Serializer
  attributes :id, :model, :brand, :updated_at, :created_at
end
