class Api::V1::CashierSerializer < ActiveModel::Serializer
  attributes :id, :start_date, :finish_date, :employee, :active
end
