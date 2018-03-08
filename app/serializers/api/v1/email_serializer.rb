class Api::V1::EmailSerializer < ActiveModel::Serializer
  attributes :id, :email, :email_type_id, :updated_at, :created_at
end
