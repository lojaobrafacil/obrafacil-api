class CreateOrderItems < ActiveRecord::Migration[5.2]
  def change
    create_table :order_items do |t|
      t.references :product, foreign_key: true
      t.references :order, foreign_key: true
      t.float :price
      t.integer :quantity
      t.float :cost
      t.string :description
      t.float :tax_industrialized_product
      t.float :tax_substitution
      t.float :tax_circulation_commodity_services
      t.integer :quantity_downloaded
      t.integer :checker_employee_id, foreign_key: true
      t.integer :output_company_id, foreign_key: true
      t.datetime :billing_at
      t.string :common_mercosur_nomenclature

      t.timestamps
    end
  end
end
