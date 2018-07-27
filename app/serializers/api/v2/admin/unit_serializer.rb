class Api::V2::Admin::UnitSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :updated_at, :created_at
end
