class CreateCfops < ActiveRecord::Migration[5.1]
  def change
    create_table :cfops do |t|
      t.integer :code
      t.text :description

      t.timestamps
    end
  end
end
