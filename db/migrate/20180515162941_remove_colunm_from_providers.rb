class RemoveColunmFromProviders < ActiveRecord::Migration[5.1]
  def change
    remove_column :providers, :invoice_sale, :string
    remove_column :providers, :invoice_return, :string
    remove_column :providers, :pis_percent, :string
    remove_column :providers, :confins_percent, :string
    remove_column :providers, :icmsn_percent, :string
    remove_column :providers, :between_states_percent, :string
  end
end
