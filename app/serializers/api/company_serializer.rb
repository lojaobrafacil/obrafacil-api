class Api::CompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :fantasy_name, :federal_registration, :state_registration,
             :birth_date, :tax_regime, :description, :invoice_sale, :invoice_return,
             :pis_percent, :confins_percent, :icmsn_percent, :updated_at, :created_at

  has_many :addresses
  has_many :phones
  has_many :emails
end
