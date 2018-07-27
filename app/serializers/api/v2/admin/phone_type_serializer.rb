class Api::V2::Admin::PhoneTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :updated_at, :created_at
end
