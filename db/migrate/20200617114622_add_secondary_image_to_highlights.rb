class AddSecondaryImageToHighlights < ActiveRecord::Migration[5.2]
  def change
    add_column :highlights, :secondaryImage, :string
  end
end
