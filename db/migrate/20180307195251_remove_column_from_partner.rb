class RemoveColumnFromPartner < ActiveRecord::Migration[5.1]
  def change
    remove_column :partners, :limit
    remove_column :partners, :tax_regime
    remove_column :partners, :international_registration
  end
end
