class Api::V2::Admin::EmployeeSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :federal_registration, :state_registration, :active,
  :birth_date, :renewal_date, :admin, :change_partners, :change_clients, :change_suppliers, 
  :change_cashiers, :generate_nfe, :import_xml, :change_products, :order_client, :order_devolution,
  :order_cost, :order_done, :order_price_reduce, :order_inactive, :order_creation, :limit_price_percentage, 
  :commission_percent, :description, :updated_at, :created_at

  has_many :addresses
  has_many :phones
  has_many :emails
end
