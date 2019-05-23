class CreateCoupons < ActiveRecord::Migration[5.2]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :code
      t.float :discount
      t.integer :status
      t.integer :kind
      t.float :max_value
      t.datetime :expired_at
      t.datetime :starts_at
      t.integer :total_uses
      t.integer :client_uses
      t.boolean :shipping
      t.boolean :logged
      t.text :description

      t.timestamps
    end
  end
end
