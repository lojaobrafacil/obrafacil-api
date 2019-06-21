class ApiPartner::ZipcodeSerializer < ActiveModel::Serializer
  attributes :id, :code, :place, :neighborhood, :city_id, :city_name,
             :state_id, :state_name, :ibge, :gia, :created_at, :updated_at

  def city_name
    object.city.name if object.city
  end

  def state_id
    object.city.state_id if object.city
  end

  def state_name
    object.city.state.name if object.city
  end
end
