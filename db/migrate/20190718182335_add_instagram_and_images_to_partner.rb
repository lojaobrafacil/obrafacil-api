class AddInstagramAndImagesToPartner < ActiveRecord::Migration[5.2]
  def change
    add_column :partners, :instagram, :string
    add_column :partners, :avatar, :string
    add_column :partners, :aboutme, :text
    rename_column :partners, :image, :project_image
  end
end
