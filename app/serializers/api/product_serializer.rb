class Api::ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :ipi,
             :barcode, :reduction, :weight, :height, :width, :length,
             :kind, :status, :sku, :sku_xml, :images,
             :updated_at, :created_at, :stocks
  has_one :sub_category
  has_one :unit
  has_one :supplier

  def images
    object.image_products
  end

  def stocks
    object.stocks.map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(Api::ProductStockSerializer.new(u)) }
  end
end
