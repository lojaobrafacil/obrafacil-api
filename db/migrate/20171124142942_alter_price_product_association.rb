class AlterPriceProductAssociation < ActiveRecord::Migration[5.1]
  def change
    remove_column  :prices, :product_id
    add_reference  :prices, :company_product
  end
end
