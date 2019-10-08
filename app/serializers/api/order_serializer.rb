class Api::OrderSerializer < ActiveModel::Serializer
  attributes :id, :kind, :exclusion_date, :description, :discont, :freight,
             :billing_date, :file, :selected_margin, :employee, :cashier, :client, :carrier,
             :company, :updated_at, :created_at
end
