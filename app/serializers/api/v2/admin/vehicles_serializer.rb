class Api::V2::Admin::UnitSerializer < ActiveModel::Serializer
  attributes :id, :model, :brand, :updated_at, :created_at
end
