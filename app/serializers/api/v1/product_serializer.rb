class Api::V1::ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :common_nomenclature_mercosur, :added_value_tax,
  :brand, :cost, :tax_industrialized_products, :profit_margin, :aliquot_merchandise_tax,
  :bar_code, :tax_substitution, :tax_reduction, :discount, :weight, :height, :width,
  :length, :color, :code_tax_substitution_specification, :kind, :active, :sub_category,
  :unit, :company_products
end
