class ApiPublic::ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :images, :price

  def price
    object.prices.find_by(margin: Margin.find_by(order: 0)).value
  end
end
