class Api::CouponByCodeSerializer < ActiveModel::Serializer
  attributes :id, :name, :code, :discount, :status, :kind, :max_value,
             :expired_at, :starts_at, :total_uses, :client_uses, :shipping,
             :logged, :description, :created_at, :updated_at
  has_one :partner

  def partner
    object.partner.as_json(only: [:id, :name, :status])
  end
end
