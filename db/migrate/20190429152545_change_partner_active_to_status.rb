class ChangePartnerActiveToStatus < ActiveRecord::Migration[5.2]
  def self.up
    add_column :partners, :status, :integer
    Partner.where(active: true).update_all(status: 1)
    Partner.where.not(active: true).update_all(status: 2)
    remove_column :partners, :active
  end

  def self.down
    add_column :partners, :active, :boolean
    Partner.where(status: 1).update_all(active: true)
    Partner.where.not(status: 1).update_all(active: false)
    remove_column :partners, :status
  end
end
