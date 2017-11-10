class Api::V1::EmailSerializer < ActiveModel::Serializer
  attributes :id, :email, :contact, :emailable_id, :emailable_type, :email_type
end
