class Api::V1::ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :ncm, :icms, :ipi, :cest, 
      :bar_code, :reduction, :weight, :height, :width, :length,
      :kind, :active, :unit_id, :sku, :sku_xml, :sub_category_id, :provider_id, 
      :category_id, :company_products, :updated_at, :created_at

  def category_id
    object.sub_category ? object.sub_category.category_id : nil
  end
end
