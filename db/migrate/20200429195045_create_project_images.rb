class CreateProjectImages < ActiveRecord::Migration[5.2]
  def change
    remove_column :partner_projects, :images, :array, default: []
    create_table :project_images do |t|
      t.string :attachment
      t.references :partner_project, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
