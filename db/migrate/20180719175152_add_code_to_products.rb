class AddCodeToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :code, :integer, limit: 4
  end
end
