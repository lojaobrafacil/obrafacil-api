class Api::V2::Admin::StateSerializer < ActiveModel::Serializer
  attributes :id, :name, :acronym, :region, :updated_at, :created_at
end
