class RemoveCodeFromProduct < ActiveRecord::Migration[5.2]
  def change
    remove_column :products, :code, :integer
    add_column :company_products, :code, :integer
  end
end
