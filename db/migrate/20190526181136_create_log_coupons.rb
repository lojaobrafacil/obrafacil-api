class CreateLogCoupons < ActiveRecord::Migration[5.2]
  def change
    create_table :log_coupons do |t|
      t.references :coupon, foreign_key: true
      t.string :external_order_id
      t.string :client_federal_registration

      t.timestamps
    end
  end
end
