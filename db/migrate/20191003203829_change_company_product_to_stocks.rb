class ChangeCompanyProductToStocks < ActiveRecord::Migration[5.2]
  def change
    rename_table :company_products, :stocks
    remove_column :stocks, :code
    add_column :stocks, :pmva, :float, precision: 5, scale: 2
    add_column :stocks, :vbc, :float, precision: 5, scale: 2
    add_column :stocks, :vbcst, :float, precision: 5, scale: 2
    add_column :stocks, :vicms, :float, precision: 5, scale: 2
    add_column :stocks, :picms, :float, precision: 5, scale: 2
    add_column :stocks, :vicmsst, :float, precision: 5, scale: 2
    add_column :stocks, :picmsst, :float, precision: 5, scale: 2
  end
end
