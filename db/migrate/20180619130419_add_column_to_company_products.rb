class AddColumnToCompanyProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :company_products, :cost, :float
    add_column :company_products, :discount, :float
    add_column :company_products, :st, :float
    add_column :company_products, :margin, :float
  end
end
