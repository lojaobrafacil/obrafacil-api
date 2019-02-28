class Api::EmailSerializer < ActiveModel::Serializer
  attributes :id, :email, :contact, :primary, :email_type_id, :email_type_name, :updated_at, :created_at

  def email_type_name
    object.email_type.name if object.email_type
  end
end
