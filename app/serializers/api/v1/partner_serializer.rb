class Api::V1::PartnerSerializer < ActiveModel::Serializer
  attributes :id, :name, :federal_tax_number, :state_registration, :kind, :active, 
  :birth_date, :renewal_date, :description, :order_description, :origin, :percent, 
  :agency, :account, :favored, :bank, :billing_type, :user, :phones, :emails, 
  :addresses, :updated_at, :created_at

end
