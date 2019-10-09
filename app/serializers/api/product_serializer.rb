class Api::ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :barcode, :weight, :height, :width,
             :length, :color, :kind, :sku, :sku_xml, :ipi, :reduction,
             :suggested_price, :supplier_id, :suggested_price_site, :suggested_price_role,
             :status, :created_at, :updated_at, :description, :stocks
  has_one :sub_category
  has_one :unit
  has_one :supplier
  has_one :deleted_by

  def images
    object.image_products
  end

  def stocks
    object.stocks.map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(Api::ProductStockSerializer.new(u)) }
  end

  def deleted_by
    object.deleted_by.as_json(only: [:id, :name])
  end
end
