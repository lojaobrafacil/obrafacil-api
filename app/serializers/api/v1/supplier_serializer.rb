class Api::V1::SupplierSerializer < ActiveModel::Serializer
  attributes :id, :name, :fantasy_name, :federal_tax_number, :state_registration,
  :kind, :birth_date, :tax_regime, :description, :billing_type_id, :user_id, 
  :updated_at, :created_at

  has_many :addresses
  has_many :phones
  has_many :emails
end
