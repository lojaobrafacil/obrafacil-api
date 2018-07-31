class ChangeClientFederalTaxNumberToFederalRegistration < ActiveRecord::Migration[5.1]
  def change
    rename_column :clients, :federal_tax_number, :federal_registration
  end
  
end
