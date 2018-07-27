class Api::V2::Admin::ProductSerializer < ActiveModel::Serializer
  attributes :id, :code, :name, :description, :ncm, :icms, :ipi, :cest, 
      :bar_code, :reduction, :weight, :height, :width, :length,
      :kind, :active, :unit_id, :sku, :sku_xml, :sub_category_id, :supplier_id,
      :supplier_name, :supplier_fantasy_name, :category_id, :updated_at, :created_at, :images
      
  has_many :company_products

  def images
    object.image_products
  end

  def category_id
    object.sub_category ? object.sub_category.category_id : nil
  end

  def supplier_name
    object.supplier_id ? object.supplier.name : nil
  end

  def supplier_fantasy_name
    object.supplier_id ? object.supplier.fantasy_name : nil
  end

end
