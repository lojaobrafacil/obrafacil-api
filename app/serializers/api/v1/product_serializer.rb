class Api::V1::ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :ncm, :icms, :ipi, :cest, 
      :bar_code, :reduction, :weight, :height, :width, :length,
      :kind, :active, :unit_id, :sku, :sku_xml, :sub_category_id, :provider_id,
      :provider_name, :category_id, :updated_at, :created_at

  has_many :image_products
  has_many :company_products

  def category_id
    object.sub_category ? object.sub_category.category_id : nil
  end

  def provider_name
    object.provider_id ? object.provider.name : nil
  end

end
