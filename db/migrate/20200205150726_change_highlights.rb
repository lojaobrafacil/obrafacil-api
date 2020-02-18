class ChangeHighlights < ActiveRecord::Migration[5.2]
  def change
    rename_column :highlights, :title_1, :title
    rename_column :highlights, :title_2, :subtitle
    rename_column :highlights, :content_1, :metadata
    rename_column :highlights, :image_1, :image
    remove_column :highlights, :content_2, :text
    remove_column :highlights, :content_3, :text
    remove_column :highlights, :image_2, :string
    remove_column :highlights, :image_3, :string
  end
end
