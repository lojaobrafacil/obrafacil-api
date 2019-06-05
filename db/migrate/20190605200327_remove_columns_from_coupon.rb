class RemoveColumnsFromCoupon < ActiveRecord::Migration[5.2]
  def change
    remove_column :coupons, :max_value, :string
    remove_column :coupons, :shipping, :boolean
    remove_column :coupons, :logged, :boolean
  end
end
