class CreateCommissions < ActiveRecord::Migration[5.1]
  def change
    create_table :commissions do |t|
      t.references :partner, foreign_key: true
      t.integer :order_id
      t.datetime :order_date
      t.float :order_price
      t.string :client_name
      t.integer :points
      t.float :percent
      t.datetime :percent_date
      t.datetime :sent_date

      t.timestamps
    end
  end
end
