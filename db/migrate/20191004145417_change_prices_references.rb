class ChangePricesReferences < ActiveRecord::Migration[5.2]
  def change
    remove_reference :prices, :company_product, index: true
    add_reference :prices, :stock, index: true, foreign_key: true
  end
end
