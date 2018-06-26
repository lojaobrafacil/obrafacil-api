class RemoveKindFromCompanies < ActiveRecord::Migration[5.1]
  def change
    remove_column :companies, :kind, :string
    remove_column :companies, :between_states_percent
    remove_column :companies, :billing_type_id
  end
end
