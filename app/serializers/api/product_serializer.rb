class Api::ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :ncm, :icms, :ipi, :cest,
             :bar_code, :reduction, :weight, :height, :width, :length,
             :kind, :active, :sku, :sku_xml, :images,
             :updated_at, :created_at, :company_products
  has_one :sub_category
  has_one :unit
  has_one :supplier

  def images
    object.image_products
  end

  def company_products
    object.company_products.map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(Api::ProductStockSerializer.new(u)) }
  end
end
