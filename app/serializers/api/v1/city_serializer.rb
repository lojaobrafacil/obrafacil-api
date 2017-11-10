class Api::V1::CitySerializer < ActiveModel::Serializer
  attributes :id, :name, :capital, :state
end
