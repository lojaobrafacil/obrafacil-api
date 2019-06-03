class RemoveUserToSupplier < ActiveRecord::Migration[5.1]
  def change
    remove_reference :suppliers, :user, foreign_key: true
  end
end
