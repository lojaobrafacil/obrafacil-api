class Api::V1::UnitSerializer < ActiveModel::Serializer
  attributes :id, :name, :description
end
