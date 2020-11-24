class Api::ProductStockSerializer < ActiveModel::Serializer
  attributes :id, :stock, :stock_max, :stock_min, :company, :updated_at, :created_at

  def company
    object.company&.as_json(only: [:id, :name])
  end
end
