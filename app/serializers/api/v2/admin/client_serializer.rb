class Api::V2::Admin::ClientSerializer < ActiveModel::Serializer
  attributes :id, :name, :federal_registration, :state_registration, :international_registration,
  :kind, :active, :birth_date, :renewal_date, :tax_regime, :description, :order_description,
  :limit, :billing_type_id, :billing_type_name, :user, :created_at, :updated_at

  has_many :addresses
  has_many :phones
  has_many :emails

  def billing_type_name
    object.billing_type.name if object.billing_type
  end
end
