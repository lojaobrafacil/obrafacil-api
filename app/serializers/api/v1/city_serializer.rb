class Api::V1::CitySerializer < ActiveModel::Serializer
  attributes :id, :name, :capital, :state, :updated_at, :created_at
end
