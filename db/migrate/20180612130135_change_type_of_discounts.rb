class ChangeTypeOfDiscounts < ActiveRecord::Migration[5.1]
  def change
    change_column :partners, :discount3, :string
    change_column :partners, :discount8, :string
  end
end
