class Api::V1::AddressTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :updated_at, :created_at
end
