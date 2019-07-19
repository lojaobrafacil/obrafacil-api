class CreateHighlights < ActiveRecord::Migration[5.2]
  def change
    create_table :highlights do |t|
      t.string :title_1
      t.string :title_2
      t.text :content_1
      t.text :content_2
      t.text :content_3
      t.string :image_1
      t.string :image_2
      t.string :image_3
      t.string :link
      t.datetime :expires_at
      t.datetime :starts_in
      t.integer :status, default: 1
      t.integer :kind, default: 0
      t.integer :position, default: 1

      t.timestamps
    end
  end
end
