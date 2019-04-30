class ChangePartnerActiveToStatus < ActiveRecord::Migration[5.2]
  def self.up
    add_column :partners, :status, :integer
    Partner.all.each do |partner|
      partner.active ? partner.update(status: 1) : partner.update(status: 2)
    end
    remove_column :partners, :active
  end

  def self.down
    add_column :partners, :active, :boolean
    Partner.all.each do |partner|
      partner.status == 1 ? partner.update(active: true) : partner.update(active: false)
    end
    remove_column :partners, :status
  end
end
