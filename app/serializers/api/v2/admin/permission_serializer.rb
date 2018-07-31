class Api::V2::Admin::PermissionSerializer < ActiveModel::Serializer
  attributes :id, :name, :updated_at, :created_at
end
