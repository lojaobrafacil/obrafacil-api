class CreateMargins < ActiveRecord::Migration[5.2]
  def change
    create_table :margins do |t|
      t.float :value, precision: 5, scale: 2
      t.integer :order, inclusion: 1..10

      t.timestamps
    end
  end
end
