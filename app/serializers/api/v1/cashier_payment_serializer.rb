class Api::V1::CashierPaymentSerializer < ActiveModel::Serializer
  attributes :id, :cashier, :payment_method, :value, :updated_at, :created_at
end
