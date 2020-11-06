class Api::OrderItemsSerializer < ActiveModel::Serializer
  attributes :id, :product_id, :order_id, :price, :quantity, :cost, :description,
             :tax_industrialized_product, :tax_substitution, :supplier_name, :billing_at,
             :tax_circulation_commodity_services, :quantity_downloaded, :checker_employee_id,
             :output_company_id, :common_mercosur_nomenclature, :environment_id, :environment_complement
  has_one :environment

  def supplier_name
    object.product.supplier&.fantasy_name
  end
end
