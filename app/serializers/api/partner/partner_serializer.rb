class Api::Partner::PartnerSerializer < ActiveModel::Serializer
  attributes :id, :name, :federal_registration, :state_registration, :agency, :account,
  :favored, :bank_name, :discount3, :discount5, :discount8

  has_many :addresses
  has_many :phones
  has_many :emails

  def bank_name
    object.bank ? object.bank.name : nil
  end
end
