class AddAndRemoveFromProducts < ActiveRecord::Migration[5.1]
  def change
    # add
    add_column :products, :icms, :float
    add_column :products, :ncm, :integer
    add_column :products, :ipi, :float
    add_column :products, :cest, :integer
    add_column :products, :reduction, :float
    # remove
    remove_column :products, :added_value_tax
    remove_column :products, :cost
    remove_column :products, :profit_margin
    remove_column :products, :aliquot_merchandise_tax
    remove_column :products, :common_nomenclature_mercosur
    remove_column :products, :tax_industrialized_products
    remove_column :products, :tax_substitution
    remove_column :products, :tax_reduction
    remove_column :products, :discount
    remove_column :products, :code_tax_substitution_specification
  end
end
