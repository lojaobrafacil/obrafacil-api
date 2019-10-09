class Api::StockSerializer < ActiveModel::Serializer
  attributes :id, :stock, :stock_max, :stock_min, :cost, :discount,
             :st, :margin, :pmva, :vbc, :vbcst, :vicms, :picms, :vicmsst,
             :picmsst, :updated_at, :created_at
  has_one :company
  has_one :product
end
