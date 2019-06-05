class Api::CouponByCodeSerializer < ActiveModel::Serializer
  attributes :id, :name, :code, :discount, :status, :kind,
             :expired_at, :starts_at, :total_uses, :client_uses,
             :description, :created_at, :updated_at
  has_one :partner

  def partner
    object.partner.as_json(only: [:id, :name, :status])
  end
end
