class Api::V1::EmployeeSerializer < ActiveModel::Serializer
  attributes :id, :name, :federal_tax_number, :state_registration, :active,
  :birth_date, :renewal_date, :commission_percent, :description, :user
end
