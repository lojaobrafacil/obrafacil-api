class AddFavoredFederalRegistrationToPartner < ActiveRecord::Migration[5.2]
  def change
    add_column :partners, :favored_federal_registration, :string
  end
end
