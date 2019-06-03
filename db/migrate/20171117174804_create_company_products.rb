class CreateCompanyProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :company_products do |t|
      t.float :stock
      t.float :stock_max
      t.float :stock_min
      t.datetime :stock_date
      t.references :company, foreign_key: true
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
