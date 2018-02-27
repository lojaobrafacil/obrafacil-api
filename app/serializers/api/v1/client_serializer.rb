class Api::V1::ClientSerializer < ActiveModel::Serializer
  attributes :id, :name, :federal_tax_number, :state_registration, :international_registration,
  :kind, :active, :birth_date, :renewal_date, :tax_regime, :description, :order_description,
  :limit, :billing_type, :user, :phones, :emails, :addresses, :created_at, :updated_at
end
