class Api::V1::PhoneTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :updated_at, :created_at
end
