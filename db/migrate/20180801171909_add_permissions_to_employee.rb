class AddPermissionsToEmployee < ActiveRecord::Migration[5.1]
  def change
    add_column :employees, :admin, :boolean, default: false
    add_column :employees, :partner, :boolean, default: false
    add_column :employees, :client, :boolean, default: false
    add_column :employees, :order, :boolean, default: false
    add_column :employees, :limit_price_percentage, :integer, default: 3
  end
end
