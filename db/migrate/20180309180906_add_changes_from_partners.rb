class AddChangesFromPartners < ActiveRecord::Migration[5.1]
  def change
    # partner
    remove_column :partners, :order_description
    remove_column :partners, :billing_type_id
    remove_column :partners, :birth_date
    add_column :partners, :stated_date, :datetime
    add_column :partners, :ocupation, :string
    # users
    add_column :users, :federal_registration, :string
  end
end
