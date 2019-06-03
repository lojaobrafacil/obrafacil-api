class CreateCarriers < ActiveRecord::Migration[5.1]
  def change
    create_table :carriers do |t|
      t.string :name
      t.string :federal_tax_number
      t.string :state_registration
      t.integer :kind
      t.text :description
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
