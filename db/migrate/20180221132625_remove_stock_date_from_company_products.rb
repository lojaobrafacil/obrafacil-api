class RemoveStockDateFromCompanyProducts < ActiveRecord::Migration[5.1]
  def change
    remove_column  :company_products, :stock_date
  end
end
