class AddPermissions2ToEmployee < ActiveRecord::Migration[5.1]
  def self.up
    rename_column :employees, :order, :order_creation
    rename_column :employees, :client, :clients
    rename_column :employees, :partner, :partners
    add_column :employees, :cashier, :boolean, default: false
    add_column :employees, :nfe, :boolean, default: false
    add_column :employees, :xml, :boolean, default: false
    add_column :employees, :products, :boolean, default: false
    add_column :employees, :order_client, :boolean, default: false
    add_column :employees, :order_devolution, :boolean, default: false
    add_column :employees, :order_cost, :boolean, default: false
    add_column :employees, :order_done, :boolean, default: false
    add_column :employees, :order_price_reduce, :boolean, default: false
    add_column :employees, :order_inactive, :boolean, default: false
  end
  
  def self.down
    rename_column :employees, :order_creation, :order
    rename_column :employees, :clients, :client
    rename_column :employees, :partners, :partner
    remove_column :employees, :cashier
    remove_column :employees, :nfe
    remove_column :employees, :xml
    remove_column :employees, :product
    remove_column :employees, :order_client
    remove_column :employees, :order_devolution
    remove_column :employees, :order_cost
    remove_column :employees, :order_done
    remove_column :employees, :order_price_reduce
    remove_column :employees, :order_inactive
  end
end
