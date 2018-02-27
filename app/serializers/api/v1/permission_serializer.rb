class Api::V1::PermissionSerializer < ActiveModel::Serializer
  attributes :id, :name, :updated_at, :created_at
end
