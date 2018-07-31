class Api::V2::Admin::EmailTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :updated_at, :created_at
end
