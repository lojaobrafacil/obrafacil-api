class RemoveUserToCompany < ActiveRecord::Migration[5.1]
  def self.up
    remove_reference :companies, :user
  end

  def self.down
    add_reference :companies, :users, index: true
  end
end
