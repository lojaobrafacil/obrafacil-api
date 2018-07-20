class ChangeNameOfProviders < ActiveRecord::Migration[5.1]
  def self.up
    remove_index :providers, :billing_type_id
    remove_index :providers, :user_id
    remove_reference :products, :provider
    rename_table :providers, :suppliers
    add_index :suppliers, :billing_type_id
    add_index :suppliers, :user_id
    add_reference :products, :supplier, index: true
  end

  def self.down
    remove_index :suppliers, :billing_type_id
    remove_index :suppliers, :user_id
    remove_reference :products, :supplier
    rename_table :suppliers, :providers
    add_index :providers, :billing_type_id
    add_index :providers, :user_id
    add_reference :products, :provider, index: true
  end
end
