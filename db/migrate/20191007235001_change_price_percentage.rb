class ChangePricePercentage < ActiveRecord::Migration[5.2]
  def change
    remove_reference :orders, :price_percentage
    add_column :orders, :selected_margin, :integer, limit: 1
    add_column :companies, :margins, :json
    rename_column :employees, :limit_price_percentage, :limit_margin
    rename_column :clients, :limit_pricing_percentage, :limit_margin
    drop_table :users
    drop_table :price_percentages
  end
end
