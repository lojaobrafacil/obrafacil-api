class Api::SimpleEmployeeSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :phone, :celphone

  def phone
    object.formatted_phone
  end

  def celphone
    object.formatted_celphone
  end
end
