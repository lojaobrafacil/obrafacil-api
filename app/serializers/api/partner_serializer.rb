class Api::PartnerSerializer < ActiveModel::Serializer
  attributes :id, :name, :federal_registration, :state_registration, :kind, :active, 
  :started_date, :renewal_date, :description, :origin, :percent, :agency, :account,
  :favored, :bank_id, :bank_name, :ocupation, :discount3, :discount5, :discount8, 
  :cash_redemption, :updated_at, :created_at

  has_many :addresses
  has_many :phones
  has_many :emails
  has_one :user

  def bank_name
    object.bank ? object.bank.name : nil
  end
end
