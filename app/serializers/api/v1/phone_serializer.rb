class Api::V1::PhoneSerializer < ActiveModel::Serializer
  attributes :id, :phone, :phone_type_id, :updated_at, :created_at
end
