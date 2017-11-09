class CreatePricePercentages < ActiveRecord::Migration[5.1]
  def change
    create_table :price_percentages do |t|
      t.float :margin
      t.integer :kind

      t.timestamps
    end
  end
end
