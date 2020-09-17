class AddCanPublishedToPartner < ActiveRecord::Migration[5.2]
  def change
    add_column :partners, :can_published, :boolean, default: false
  end
end
