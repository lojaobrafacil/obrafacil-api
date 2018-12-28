class Api::PhoneSerializer < ActiveModel::Serializer
  attributes :id, :phone, :contact, :phone_type_id, :phone_type_name, :updated_at, :created_at

  def phone_type_name
    object.phone_type.name if object.phone_type
  end

  def phone
    begin
      num = object.phone
      if num&.size == 13
        num.split("+55")[1].insert(0, "(").insert(3, ") ").insert(9, "-")
      elsif num&.size == 14
        num.split("+55")[1].insert(0, "(").insert(3, ") ").insert(10, "-")
      else
        num
      end
    rescue
      object.phone
    end
  end
end
