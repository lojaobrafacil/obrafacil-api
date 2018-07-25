class DropEmployee < ActiveRecord::Migration[5.1]
  def self.up
    remove_column :cashiers, :employee_id
    remove_column :orders, :employee_id
    drop_table :employees
  end
  def self.down
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
    
    add_reference :cashiers, :employee_id, index: true
    add_reference :orders, :employee_id, index: true
  end
end
