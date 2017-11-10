class Api::V1::AddressSerializer < ActiveModel::Serializer
  attributes :id, :street, :neighborhood, :zipcode, :ibge, :gia, :complement,
    :description, :address_type, :city, :addressable_id, :addressable_type,
    :updated_at, :created_at
end
