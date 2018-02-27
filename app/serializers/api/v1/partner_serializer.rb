class Api::V1::PartnerSerializer < ActiveModel::Serializer
  attributes :id, :name, :federal_tax_number, :state_registration, :international_registration,
  :kind, :active, :birth_date, :renewal_date, :tax_regime, :description, :order_description,
  :limit, :origin, :percent, :agency, :account, :favored, :bank, :billing_type, :user, 
  :phones, :emails, :addresses, :updated_at, :created_at

end
