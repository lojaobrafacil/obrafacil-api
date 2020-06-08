class CreateDeliveries < ActiveRecord::Migration[5.2]
  def change
    create_table :deliveries do |t|
      t.references :order, foreign_key: true
      t.integer :external_order_id, index: true
      t.string :recipient, comment: "Client name for delivery."
      t.string :delivered_to, comment: "field intended for the recipient."
      t.integer :separator_id, index: true, comment: "Employee: Separator of delivery."
      t.integer :driver_id, index: true, comment: "Employee: Driver of delivery."
      t.integer :checker_id, index: true, comment: "Employee: Checker of order."
      t.references :company, foreign_key: true
      t.string :phone
      t.string :email
      t.string :street
      t.string :zipcode
      t.string :complement
      t.string :neighborhood
      t.string :street_number
      t.references :city, foreign_key: true
      t.datetime :checked_at
      t.float :freight
      t.integer :status, comment: "Enumerate."
      t.date :expected_delivery_in, comment: "Expected delivery date."
      t.datetime :delivered_at
      t.datetime :left_delivery_at
      t.datetime :separated_at
      t.datetime :left_warehouse_at
      t.text :remark

      t.timestamps
    end

    add_column :employees, :can_separate, :boolean, default: false
    add_column :employees, :can_deliver, :boolean, default: false
    add_column :employees, :can_check_order, :boolean, default: false
  end
end
