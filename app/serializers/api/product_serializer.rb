class Api::ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :barcode, :weight, :height,
             :width, :length, :color, :kind, :sku, :sku_xml, :ipi,
             :status, :deleted_at, :supplier_id, :supplier_discount, :cost,
             :tax_replacement, :contribution_margin, :pmva, :vbc, :vbcst, :vicms,
             :picms, :vicmsst, :picmsst, :freight, :st, :tax_reduction, :icms, :cest,
             :ncm, :images, :qrcode, :path_qrcode, :stocks, :prices, :sub_category_id,
             :unit_id, :supplier_id, :reduction, :suggested_price, :suggested_price_site,
             :suggested_price_role

  has_one :sub_category
  has_one :deleted_by

  def stocks
    object.stocks.map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(Api::ProductStockSerializer.new(u)) }
  end

  def deleted_by
    object.deleted_by.as_json(only: [:id, :name])
  end

  def prices
    object.prices.select(:id, :name, :value)
  end

  def qrcode
    object.qrcode.url
  end
end
