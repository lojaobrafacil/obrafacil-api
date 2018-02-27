class Api::V1::ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :common_nomenclature_mercosur, :added_value_tax,
  :cost, :tax_industrialized_products, :profit_margin, :aliquot_merchandise_tax,
  :bar_code, :tax_substitution, :tax_reduction, :discount, :weight, :height, :width,
  :length, :color, :code_tax_substitution_specification, :kind, :active, :category_id,
  :sub_category_id, :unit_id, :provider_id, :sku, :sku_xml, :updated_at, :created_at

  has_many :company_products, serializer: CompanyProductSerializer

  def category_id
    object.sub_category ? object.sub_category.category_id : nil
  end
end
