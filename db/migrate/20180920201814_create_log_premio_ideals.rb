class CreateLogPremioIdeals < ActiveRecord::Migration[5.2]
  def change
    create_table :log_premio_ideals do |t|
      t.integer :status
      t.text :error
      t.text :body
      t.references :partner, foreign_key: true

      t.timestamps
    end
  end
end
