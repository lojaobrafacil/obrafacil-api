class AddProviderToProduct < ActiveRecord::Migration[5.1]
  def change
    add_reference :products, :provider, foreign_key: true
    remove_column :products, :brand
  end
end
