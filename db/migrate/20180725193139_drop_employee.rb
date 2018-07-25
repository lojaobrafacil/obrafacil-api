class DropEmployee < ActiveRecord::Migration[5.1]
  def self.up
    remove_column :cashiers, :employee_id
    remove_column :orders, :employee_id
    drop_table :employees
  end
  def self.down
    create_table :employees
    add_reference :cashiers, :employee_id, index: true
    add_reference :orders, :employee_id, index: true
  end
end
