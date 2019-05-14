class RemoveDiscountsFromPartners < ActiveRecord::Migration[5.2]
  def change
    remove_column :partners, :discount3, :string
    remove_column :partners, :discount8, :string
  end
end
