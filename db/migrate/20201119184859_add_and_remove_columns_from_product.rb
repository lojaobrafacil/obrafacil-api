class AddAndRemoveColumnsFromProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :supplier_discount, :float, precision: 5, scale: 2, default: 0
    add_column :products, :cost, :float, precision: 5, scale: 2, default: 0
    add_column :products, :tax_replacement, :float, precision: 5, scale: 2, default: 0
    add_column :products, :contribution_margin, :float, precision: 5, scale: 2, default: 0
    add_column :products, :pmva, :float, precision: 5, scale: 2, default: 0
    add_column :products, :vbc, :float, precision: 5, scale: 2, default: 0
    add_column :products, :vbcst, :float, precision: 5, scale: 2, default: 0
    add_column :products, :vicms, :float, precision: 5, scale: 2, default: 0
    add_column :products, :picms, :float, precision: 5, scale: 2, default: 0
    add_column :products, :vicmsst, :float, precision: 5, scale: 2, default: 0
    add_column :products, :picmsst, :float, precision: 5, scale: 2, default: 0
    add_column :products, :freight, :float, precision: 5, scale: 2, default: 0
    add_column :products, :st, :float, precision: 5, scale: 2, default: 0
    add_column :products, :tax_reduction, :float, precision: 5, scale: 2, default: 0
    add_column :products, :icms, :float, precision: 5, scale: 2, default: 0
    add_column :products, :cest, :string
    add_column :products, :ncm, :string
    add_column :stocks, :reserve, :integer, default: 0

    remove_column :stocks, :discount, :float, precision: 5, scale: 2, default: 0
    remove_column :stocks, :cost, :float, precision: 5, scale: 2, default: 0
    remove_column :stocks, :st, :float, precision: 5, scale: 2, default: 0
    remove_column :stocks, :margin, :float, precision: 5, scale: 2, default: 0
    remove_column :stocks, :pmva, :float, precision: 5, scale: 2, default: 0
    remove_column :stocks, :vbc, :float, precision: 5, scale: 2, default: 0
    remove_column :stocks, :vbcst, :float, precision: 5, scale: 2, default: 0
    remove_column :stocks, :vicms, :float, precision: 5, scale: 2, default: 0
    remove_column :stocks, :picms, :float, precision: 5, scale: 2, default: 0
    remove_column :stocks, :vicmsst, :float, precision: 5, scale: 2, default: 0
    remove_column :stocks, :picmsst, :float, precision: 5, scale: 2, default: 0
  end
end
