class AddPrimaryToEmailsAndPhones < ActiveRecord::Migration[5.2]
  def change
    add_column :emails, :primary, :boolean, default: false
    add_column :phones, :primary, :boolean, default: false
  end
end
