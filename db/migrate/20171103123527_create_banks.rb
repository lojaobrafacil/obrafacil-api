class CreateBanks < ActiveRecord::Migration[5.1]
  def change
    create_table :banks do |t|
      t.integer :code
      t.string :name
      t.string :slug
      t.text :description

      t.timestamps
    end
  end
end
