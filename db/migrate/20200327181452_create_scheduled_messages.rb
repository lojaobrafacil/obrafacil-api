class CreateScheduledMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :scheduled_messages do |t|
      t.string :name, null: false
      t.string :text, null: false
      t.integer :status, default: 0
      t.string :receiver_type, null: false
      t.text :receiver_ids, array: true, default: []
      t.date :starts_at, null: false, default: -> { "now()" }
      t.date :finished_at
      t.date :last_execution
      t.date :next_execution
      t.integer :frequency, null: false, default: 1
      t.integer :frequency_type, null: false, default: 0
      t.string :repeat
      t.references :created_by, index: true, foreign_key: { to_table: :employees }

      t.timestamps
    end

    add_column :employees, :change_scheduled_messages, :boolean, default: false
  end
end
