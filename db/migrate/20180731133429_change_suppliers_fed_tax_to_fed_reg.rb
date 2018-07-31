class ChangeSuppliersFedTaxToFedReg < ActiveRecord::Migration[5.1]
  def change
    rename_column :suppliers, :federal_tax_number, :federal_registration
  end
end
