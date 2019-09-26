class ChangePercentFromPartner < ActiveRecord::Migration[5.2]
  def change
    change_column :partners, :percent, :float, precision: 5, scale: 2
  end
end
