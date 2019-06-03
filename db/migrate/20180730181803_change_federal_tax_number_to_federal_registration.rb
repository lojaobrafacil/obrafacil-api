class ChangeFederalTaxNumberToFederalRegistration < ActiveRecord::Migration[5.1]
  def self.up
    rename_column :clients, :federal_tax_number, :federal_registration
    rename_column :suppliers, :federal_tax_number, :federal_registration
    rename_column :partners, :federal_tax_number, :federal_registration
    rename_column :carriers, :federal_tax_number, :federal_registration
    rename_column :companies, :federal_tax_number, :federal_registration
  end
  def self.down
    rename_column :clients, :federal_registration, :federal_tax_number
    rename_column :suppliers, :federal_registration, :federal_tax_number
    rename_column :partners, :federal_registration, :federal_tax_number
    rename_column :carriers, :federal_registration, :federal_tax_number
    rename_column :companies, :federal_registration, :federal_tax_number
  end
end
