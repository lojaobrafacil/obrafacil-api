class CreatePiVouchers < ActiveRecord::Migration[5.2]
  def change
    create_table :pi_vouchers do |t|
      t.datetime :expiration_date
      t.float :value
      t.string :attachment
      t.datetime :used_at
      t.datetime :send_email_at
      t.integer :status, default: 1
      t.datetime :received_at
      t.references :company, foreign_key: true
      t.references :partner, foreign_key: true

      t.timestamps
    end
  end
end
