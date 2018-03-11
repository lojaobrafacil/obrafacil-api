class Api::V1::UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :federal_registration, :auth_token
  :created_at, :updated_at
end
