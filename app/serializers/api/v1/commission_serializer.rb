class Api::V1::CommissionSerializer < ActiveModel::Serializer
  attributes :id, :order_id, :order_date, :order_price, :client_name, 
  :points, :percent, :percent_date, :sent_date, :created_at, :updated_at, 
  :partner_id
end