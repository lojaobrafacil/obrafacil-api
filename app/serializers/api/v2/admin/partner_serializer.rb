class Api::V2::Admin::PartnerSerializer < ActiveModel::Serializer
  attributes :id, :name, :federal_tax_number, :state_registration, :kind, :active, 
  :started_date, :renewal_date, :description, :origin, :percent, :agency, :account,
  :favored, :bank_id, :ocupation, :user, :discount3, :discount5, :discount8, :cash_redemption,
  :updated_at, :created_at

  has_many :addresses
  has_many :phones
  has_many :emails
end
