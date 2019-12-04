class CreateOrderPayments < ActiveRecord::Migration[5.2]
  def change
    create_table :order_payments do |t|
      t.float :value, precision: 5, scale: 2
      t.references :order, foreign_key: true
      t.references :payment_method, foreign_key: true

      t.timestamps
    end
  end
end
