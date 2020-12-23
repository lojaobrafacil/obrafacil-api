class AddDeletedAtAndCommentsToCommission < ActiveRecord::Migration[5.2]
  def change
    add_column :commissions, :deleted_at, :datetime
    add_column :commissions, :comments, :text
  end
end
