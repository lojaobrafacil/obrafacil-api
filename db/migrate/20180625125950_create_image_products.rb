class CreateImageProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :image_products do |t|
      t.string :attachment
      t.references :product, foreign_key: true

      t.timestamps
    end
    remove_column :products, :images
  end
end
