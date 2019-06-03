class CreateCashierPayments < ActiveRecord::Migration[5.1]
  def change
    create_table :cashier_payments do |t|
      t.references :cashier, foreign_key: true
      t.references :payment_method, foreign_key: true
      t.float :value

      t.timestamps
    end
  end
end
