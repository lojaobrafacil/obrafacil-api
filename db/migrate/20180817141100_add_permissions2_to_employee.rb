class AddPermissions2ToEmployee < ActiveRecord::Migration[5.1]
  def self.up
    rename_column :employees, :order, :order_creation
    rename_column :employees, :client, :change_clients
    rename_column :employees, :partner, :change_partners
    add_column :employees, :change_cashiers, :boolean, default: false
    add_column :employees, :generate_nfe, :boolean, default: false
    add_column :employees, :import_xml, :boolean, default: false
    add_column :employees, :change_products, :boolean, default: false
    add_column :employees, :order_client, :boolean, default: false
    add_column :employees, :order_devolution, :boolean, default: false
    add_column :employees, :order_cost, :boolean, default: false
    add_column :employees, :order_done, :boolean, default: false
    add_column :employees, :order_price_reduce, :boolean, default: false
    add_column :employees, :order_inactive, :boolean, default: false
  end
  
  def self.down
    rename_column :employees, :order_creation, :order
    rename_column :employees, :change_clients, :client
    rename_column :employees, :change_partners, :partner
    remove_column :employees, :change_cashiers
    remove_column :employees, :generate_nfe
    remove_column :employees, :import_xml
    remove_column :employees, :change_products
    remove_column :employees, :order_client
    remove_column :employees, :order_devolution
    remove_column :employees, :order_cost
    remove_column :employees, :order_done
    remove_column :employees, :order_price_reduce
    remove_column :employees, :order_inactive
  end
end
