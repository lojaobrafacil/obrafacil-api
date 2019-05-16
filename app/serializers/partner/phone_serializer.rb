class Partner::PhoneSerializer < ActiveModel::Serializer
  attributes :id, :phone, :contact, :primary, :phone_type_id, :phone_type_name,
             :phonable_id, :phonable_type, :updated_at, :created_at

  def phone_type_name
    object.phone_type.name if object.phone_type
  end

  def phone
    object.formatted_phone
  end
end
