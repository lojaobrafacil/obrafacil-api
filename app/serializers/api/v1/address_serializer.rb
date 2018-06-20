class Api::V1::AddressSerializer < ActiveModel::Serializer
  attributes :id, :street, :number, :complement, :neighborhood, :zipcode, :ibge,
    :description, :address_type_id, :address_type_name, :city_id, :city_name, :state_id, 
    :state_name

  def state_id
    object.city.state_id if object.city
  end

  def state_name
    object.city.state.name if object.city
  end

  def city_name
    object.city.name if object.city
  end

  def address_type_name
    object.address_type.name if object.address_type
  end
end
