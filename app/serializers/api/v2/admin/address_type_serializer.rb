class Api::V2::Admin::AddressTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :updated_at, :created_at
end
