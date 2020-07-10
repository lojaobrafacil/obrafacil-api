class AddHighlightToProjectImage < ActiveRecord::Migration[5.2]
  def change
    add_column :project_images, :highlight, :boolean, default: true
  end
end
