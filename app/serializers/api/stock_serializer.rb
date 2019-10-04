class Api::StockSerializer < ActiveModel::Serializer
  attributes :id, :code, :stock, :stock_min, :stock_max,
             :cost, :discount, :st, :margin, :updated_at, :created_at
  has_one :company
  has_one :product
end
