class AddColumnsToPartners < ActiveRecord::Migration[5.2]
  def change
    add_column :partners, :site, :string
    add_column :partners, :register, :string
    add_column :partners, :deleted_at, :datetime
    add_column :partners, :deleted_by_id, :integer
    add_column :partners, :created_by_id, :integer
  end
end
