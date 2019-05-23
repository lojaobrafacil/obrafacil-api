class AddKindToApi < ActiveRecord::Migration[5.2]
  def change
    add_column :apis, :kind, :integer, default: 1
  end
end
