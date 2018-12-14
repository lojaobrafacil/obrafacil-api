class Api::UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :federal_registration, :kind, 
  :partner_id, :client_id, :created_at, :updated_at

  def partner_id
    object.partner.id if object.partner
  end

  def client_id
    object.client.id if object.client
  end
end
