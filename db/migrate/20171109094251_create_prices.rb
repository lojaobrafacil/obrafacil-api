class CreatePrices < ActiveRecord::Migration[5.1]
  def change
    create_table :prices do |t|
      t.float :price
      t.float :margin
      t.integer :kind
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
