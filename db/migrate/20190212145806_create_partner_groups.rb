class CreatePartnerGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :partner_groups do |t|
      t.string :name

      t.timestamps
    end
    add_reference :partners, :partner_group, index: true
  end
end
