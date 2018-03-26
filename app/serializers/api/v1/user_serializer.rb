class Api::V1::UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :federal_registration, :kind, :partner_id, 
  :created_at, :updated_at

  def admin
    object.admin?
  end
  
  def partner_id
    object.partner.id if object.partner
  end
end
