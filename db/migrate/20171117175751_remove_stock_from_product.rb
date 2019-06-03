class RemoveStockFromProduct < ActiveRecord::Migration[5.1]
  def change
    remove_column  :products, :stock
    remove_column  :products, :stock_max
    remove_column  :products, :stock_min
    remove_column  :products, :stock_date
    remove_column  :products, :company_id
  end
end
