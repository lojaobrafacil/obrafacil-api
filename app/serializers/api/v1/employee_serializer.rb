class Api::V1::EmployeeSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :federal_registration, :state_registration, :active,
  :birth_date, :renewal_date, :commission_percent, :description, :admin, :partner, 
  :client, :order, :limit_price_percentage, :updated_at, :created_at

  has_many :addresses
  has_many :phones
  has_many :emails
end
