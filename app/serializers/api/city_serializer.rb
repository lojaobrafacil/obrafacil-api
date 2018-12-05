class Api::CitySerializer < ActiveModel::Serializer
  attributes :id, :name, :capital, :state, :updated_at, :created_at
end
