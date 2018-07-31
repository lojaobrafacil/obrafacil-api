class ChangeFederalTaxNumberToFederalRegistration < ActiveRecord::Migration[5.1]
  def change
    rename_column :clients, :federal_tax_number, :federal_registration
    rename_column :suppliers, :federal_tax_number, :federal_registration
    rename_column :partners, :federal_tax_number, :federal_registration
    rename_column :carriers, :federal_tax_number, :federal_registration
    rename_column :companies, :federal_tax_number, :federal_registration
  end
  
end
