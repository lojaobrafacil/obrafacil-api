class Api::V2::Admin::RegionSerializer < ActiveModel::Serializer
  attributes :id, :name, :updated_at, :created_at
end
