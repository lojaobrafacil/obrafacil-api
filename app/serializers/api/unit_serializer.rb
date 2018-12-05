class Api::UnitSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :updated_at, :created_at
end
