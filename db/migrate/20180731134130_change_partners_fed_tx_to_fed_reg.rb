class ChangePartnersFedTxToFedReg < ActiveRecord::Migration[5.1]
  def change
    rename_column :partners, :federal_tax_number, :federal_registration
  end
end
