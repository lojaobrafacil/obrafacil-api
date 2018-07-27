class Api::V2::Admin::EmployeeSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :federal_registration, :state_registration, :active,
  :birth_date, :renewal_date, :commission_percent, :description, :updated_at, :created_at

  has_many :addresses
  has_many :phones
  has_many :emails
end
