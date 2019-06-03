class AddIndexFromUser < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :federal_registration, unique: true
  end
end
