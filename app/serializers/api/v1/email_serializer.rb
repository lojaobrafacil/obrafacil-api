class Api::V1::EmailSerializer < ActiveModel::Serializer
  attributes :id, :email, :contact, :email_type, :updated_at, :created_at
end
