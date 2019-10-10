class CreateLogWorkers < ActiveRecord::Migration[5.2]
  def change
    create_table :log_workers do |t|
      t.string :name
      t.json :content
      t.string :status
      t.datetime :started_at, default: -> { "CURRENT_DATE" }
      t.datetime :finished_at

      t.timestamps
    end
  end
end
