class Api::StateSerializer < ActiveModel::Serializer
  attributes :id, :name, :acronym, :region, :updated_at, :created_at
end
