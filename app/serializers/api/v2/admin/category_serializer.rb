class Api::V2::Admin::CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :updated_at, :created_at
end
