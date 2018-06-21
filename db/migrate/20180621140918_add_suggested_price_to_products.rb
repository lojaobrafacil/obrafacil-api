class AddSuggestedPriceToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :suggested_price, :float
  end
end
