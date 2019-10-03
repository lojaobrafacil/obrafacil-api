class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.string :title
      t.integer :target_id
      t.string :target_type
      t.integer :notified_id
      t.string :notified_type
      t.boolean :viewed, default: false

      t.timestamps
    end
    add_index :notifications, [:notified_id, :notified_type]
    add_index :notifications, [:target_id, :target_type]
  end
end
