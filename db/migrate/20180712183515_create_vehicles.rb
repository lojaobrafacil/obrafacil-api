class CreateVehicles < ActiveRecord::Migration[5.1]
  def change
    create_table :vehicles do |t|
      t.string :brand
      t.string :model

      t.timestamps
    end
  end
end
