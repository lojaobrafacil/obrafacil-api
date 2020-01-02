class Api::OrderSerializer < ActiveModel::Serializer
  attributes :id, :status, :exclusion_at, :description, :discount,
             :freight, :billing_at, :employee_id, :selected_margin,
             :discount_type, :status, :created_at, :updated_at
  has_one :buyer
  has_one :cashier
  has_one :carrier
  has_one :company
  has_one :partner
end
