class Api::V2::Admin::EmployeeSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :federal_registration, :state_registration, :active,
  :birth_date, :renewal_date, :admin, :partner, :client, :cashier, :nfe, :xml, :product, :order_client, 
  :order_devolution, :order_cost, :order_done, :order_price_reduce, :order_inactive, :order_creation, 
  :limit_price_percentage, :commission_percent, :description, :updated_at, :created_at

  has_many :addresses
  has_many :phones
  has_many :emails
end
