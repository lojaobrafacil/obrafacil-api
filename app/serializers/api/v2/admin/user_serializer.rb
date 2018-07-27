class Api::V1::UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :federal_registration, :kind,  :client, 
  :partner, :company, :employee, :created_at, :updated_at

  def admin
    object.admin?
  end

  def client
    object.client ? true : false
  end

  def partner
    object.partner ? true : false
  end

  def company
    object.company ? true : false
  end

  def employee
    object.employee ? true : false
  end
  
  def partner_id
    object.partner.id if object.partner
  end
end
