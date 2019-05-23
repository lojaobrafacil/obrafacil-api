class AddCouponToPartner < ActiveRecord::Migration[5.2]
  def up
    add_reference :coupons, :partner, foreign_key: true

    Partner.active.each do |partner|
      Coupon.create(partner_id: partner.id, name: partner.name, code: partner.discount5, discount: 5.0, kind: 0, status: 1, starts_at: DateTime.now(), expired_at: DateTime.now + 1.year)
    end

    remove_column :partners, :discount5
  end

  def down
    add_column :partners, :discount5
    
    Partner.active.each do |partner|
      partner.update(discount5: partner.coupon.code)
    end
    
    remove_reference :coupons, :partner, index: true, foreign_key: true
  end
end
