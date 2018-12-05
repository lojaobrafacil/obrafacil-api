class Api::CashierSerializer < ActiveModel::Serializer
  attributes :id, :start_date, :finish_date, :employee, :active, :updated_at, :created_at
end
