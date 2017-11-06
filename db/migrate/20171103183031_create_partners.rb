class CreatePartners < ActiveRecord::Migration[5.1]
  def change
    create_table :partners do |t|
      t.string :name
      t.string :federal_tax_number
      t.string :state_registration
      t.string :international_registration
      t.integer :kind
      t.boolean :active, default: true
      t.datetime :birth_date
      t.datetime :renewal_date
      t.integer :tax_regime
      t.text :description
      t.string :order_description
      t.float :limit
      t.integer :origin
      t.integer :percent
      t.string :agency
      t.string :account
      t.string :favored
      t.references :bank, foreign_key: true
      t.references :billing_type, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
