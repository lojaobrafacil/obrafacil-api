class Api::ProductStockSerializer < ActiveModel::Serializer
  attributes :id, :stock, :stock_max, :stock_min, :cost, :discount,
             :st, :margin, :pmva, :vbc, :vbcst, :vicms, :picms, :vicmsst,
             :picmsst, :company, :updated_at, :created_at

  def company
    object.company&.as_json(only: [:id, :name])
  end
end
