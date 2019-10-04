class Api::ProductStockSerializer < ActiveModel::Serializer
  attributes :id, :stock, :stock_min, :stock_max,
             :company, :cost, :discount, :st, :margin,
             :updated_at, :created_at

  def company
    object.company&.as_json(only: [:id, :name])
  end
end
