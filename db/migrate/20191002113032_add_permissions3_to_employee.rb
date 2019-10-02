class AddPermissions3ToEmployee < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :change_coupon, :boolean, default: false
    add_column :employees, :change_campain, :boolean, default: false
    add_column :employees, :change_highlight, :boolean, default: false
    add_column :employees, :change_bank, :boolean, default: false
    add_column :employees, :change_carrier, :boolean, default: false
    add_column :employees, :change_employee, :boolean, default: false
  end
end
