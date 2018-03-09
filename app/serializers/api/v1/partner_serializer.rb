class Api::V1::PartnerSerializer < ActiveModel::Serializer
  attributes :id, :name, :federal_tax_number, :state_registration, :kind, :active, 
  :stated_date, :renewal_date, :description, :origin, :percent, :agency, :account, 
  :favored, :bank, :ocupation, :user, :updated_at, :created_at

  has_many :addresses
  has_many :phones
  has_many :emails
end
