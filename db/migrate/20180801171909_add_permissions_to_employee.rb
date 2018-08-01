class AddPermissionsToEmployee < ActiveRecord::Migration[5.1]
  def self.up
    add_column :employees, :admin, :boolean, default: false
    add_column :employees, :partner, :boolean, default: false
    add_column :employees, :client, :boolean, default: false
    add_column :employees, :order, :boolean, default: false
    add_column :employees, :limit_price_percentage, :integer, default: "3"

    drop_table :permissions
  end

  def self.down
    remove_column :employees, :admin
    remove_column :employees, :partner
    remove_column :employees, :client
    remove_column :employees, :order
    remove_column :employees, :limit_price_percentage

    create_table :permissions do |t|
      t.string :name

      t.timestamps
    end
  end
end
