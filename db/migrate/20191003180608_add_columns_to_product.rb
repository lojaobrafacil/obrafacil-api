class AddColumnsToProduct < ActiveRecord::Migration[5.2]
  def change
    remove_column :products, :active
    remove_column :products, :icms
    remove_column :products, :ncm
    remove_column :products, :cest
    change_column :products, :suggested_price, :float, precision: 5, scale: 2
    rename_column :products, :bar_code, :barcode
    add_column :products, :suggested_price_site, :float, precision: 5, scale: 2
    add_column :products, :suggested_price_role, :integer, default: 0
    add_column :products, :status, :integer, default: 1
    add_column :products, :deleted_by_id, :integer
    add_column :products, :deleted_at, :datetime
  end
end
