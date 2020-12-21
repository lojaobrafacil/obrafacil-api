class AlterColumnsFromPrices < ActiveRecord::Migration[5.2]
  def change
    add_reference :prices, :product, foreign_key: true
    add_reference :prices, :margin, foreign_key: true
    remove_reference :prices, :stock, foreign_key: true
    remove_column :prices, :kind, :integer
    add_column :prices, :plataform, :string, default: 1
    add_column :prices, :name, :string
    add_column :prices, :starts_at, :datetime
    add_column :prices, :ends_at, :datetime
    rename_column :prices, :price, :value
  end
end
