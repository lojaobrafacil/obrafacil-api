class Api::AddressTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :updated_at, :created_at
end
