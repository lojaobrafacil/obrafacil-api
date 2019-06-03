class CreateProviders < ActiveRecord::Migration[5.1]
  def change
    create_table :providers do |t|
      t.string :name
      t.string :fantasy_name
      t.string :federal_tax_number
      t.string :state_registration
      t.integer :kind
      t.datetime :birth_date
      t.integer :tax_regime
      t.text :description
      t.integer :invoice_sale
      t.integer :invoice_return
      t.integer :pis_percent
      t.integer :confins_percent
      t.integer :icmsn_percent
      t.integer :between_states_percent
      t.references :billing_type, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
