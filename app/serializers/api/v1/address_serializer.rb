class Api::V1::AddressSerializer < ActiveModel::Serializer
  attributes :id, :street, :neighborhood, :zipcode, :ibge, :gia, :complement,
    :description, :address_type_id, :city_id, :updated_at, :created_at, :state_id

  def state_id
    object.city.state_id if object.city
  end
end
