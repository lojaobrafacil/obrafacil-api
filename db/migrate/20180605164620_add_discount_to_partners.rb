class AddDiscountToPartners < ActiveRecord::Migration[5.1]
  def change
    add_column :partners, :discount3, :float
    add_column :partners, :discount8, :float
  end
end
