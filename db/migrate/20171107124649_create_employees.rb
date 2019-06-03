class CreateEmployees < ActiveRecord::Migration[5.1]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :federal_tax_number
      t.string :state_registration
      t.boolean :active, default: true
      t.datetime :birth_date
      t.datetime :renewal_date
      t.integer :commission_percent
      t.text :description
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
