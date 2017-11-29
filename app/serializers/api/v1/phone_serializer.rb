class Api::V1::PhoneSerializer < ActiveModel::Serializer
  attributes :id, :phone, :contact, :phone_type, :updated_at, :created_at
end
