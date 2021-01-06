class CreatePaymentTerms < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_terms do |t|
      t.string :name
      t.integer :date1
      t.integer :date2
      t.integer :date3
      t.integer :date4
      t.integer :date5
      t.integer :date6
      t.integer :date7
      t.integer :date8
      t.integer :date9
      t.integer :date10

      t.timestamps
    end
    add_reference :orders, :payment_term, foreign_key: true
  end
end
