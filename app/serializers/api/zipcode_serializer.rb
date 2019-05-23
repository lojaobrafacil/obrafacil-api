class Api::ZipcodeSerializer < ActiveModel::Serializer
  attributes :id, :code, :place, :neighborhood, :ibge,
             :gia, :created_at, :updated_at

  has_one :city
end
