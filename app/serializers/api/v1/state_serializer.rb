class Api::V1::StateSerializer < ActiveModel::Serializer
  attributes :id, :name, :state
end
