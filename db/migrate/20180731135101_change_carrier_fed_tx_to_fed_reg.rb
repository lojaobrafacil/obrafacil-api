class ChangeCarrierFedTxToFedReg < ActiveRecord::Migration[5.1]
  def change
    rename_column :carriers, :federal_tax_number, :federal_registration
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
