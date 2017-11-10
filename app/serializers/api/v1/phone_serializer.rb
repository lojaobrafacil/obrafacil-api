class Api::V1::PhoneSerializer < ActiveModel::Serializer
  attributes :id, :phone, :contact, :phonable_id, :phonable_type, :phone_type
end
