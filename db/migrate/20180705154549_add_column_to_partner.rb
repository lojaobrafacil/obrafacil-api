class AddColumnToPartner < ActiveRecord::Migration[5.1]
  def change
    add_column :partners, :cash_redemption, :integer
    add_column :partners, :discount5, :string
  end
end
