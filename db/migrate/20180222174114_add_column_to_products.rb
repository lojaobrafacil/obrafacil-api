class AddColumnToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :sku, :string
    add_column :products, :sku_xml, :string
  end
end
