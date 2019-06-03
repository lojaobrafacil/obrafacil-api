class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.integer :kind
      t.datetime :exclusion_date
      t.text :description
      t.float :discont
      t.float :freight
      t.datetime :billing_date
      t.string :file
      t.references :price_percentage, foreign_key: true
      t.references :employee, foreign_key: true
      t.references :cashier, foreign_key: true
      t.references :client, foreign_key: true
      t.references :carrier, foreign_key: true
      t.references :company, foreign_key: true

      t.timestamps
    end
  end
end
