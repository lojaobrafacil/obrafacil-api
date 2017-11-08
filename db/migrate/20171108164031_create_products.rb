class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.string :common_nomenclature_mercosur
      t.float :added_value_tax
      t.string :brand
      t.float :cost
      t.float :tax_industrialized_products
      t.float :profit_margin
      t.integer :stock
      t.integer :stock_min
      t.integer :stock_max
      t.datetime :stock_date
      t.float :aliquot_merchandise_tax
      t.string :bar_code
      t.float :tax_substitution
      t.float :tax_reduction
      t.float :discount
      t.float :Weight
      t.float :Height
      t.float :width
      t.float :length
      t.string :color
      t.string :code_tax_substitution_specification
      t.integer :kind
      t.boolean :active, default: true
      t.references :sub_category, foreign_key: true
      t.references :unit, foreign_key: true
      t.references :company, foreign_key: true

      t.timestamps
    end
  end
end
