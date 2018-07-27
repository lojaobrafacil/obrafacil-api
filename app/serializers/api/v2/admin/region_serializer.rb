class Api::V1::RegionSerializer < ActiveModel::Serializer
  attributes :id, :name, :updated_at, :created_at
end
