class Api::VehicleSerializer < ActiveModel::Serializer
  attributes :id, :model, :brand, :updated_at, :created_at
end
