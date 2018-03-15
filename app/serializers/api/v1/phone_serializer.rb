class Api::V1::PhoneSerializer < ActiveModel::Serializer
  attributes :id, :phone, :phone_type_id, :phone_type_name, :updated_at, :created_at
  
  def phone_type_name
    object.phone_type.name if object.phone_type
  end
end
