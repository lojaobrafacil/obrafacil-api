class CreatePartnerProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :partner_projects do |t|
      t.string :name, null: false
      t.integer :environment, null: false
      t.integer :status, null: false, default: 0
      t.text :status_rmk
      t.text :description, null: false
      t.string :products
      t.date :project_date, default: -> { "NOW()" }
      t.string :city
      t.string :metadata, index: true
      t.json :images, array: true, default: []
      t.references :partner, foreign_key: true

      t.timestamps
    end
  end
end
