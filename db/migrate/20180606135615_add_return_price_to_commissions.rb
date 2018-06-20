class AddReturnPriceToCommissions < ActiveRecord::Migration[5.1]
  def change
    add_column :commissions, :return_price, :float
  end
end
