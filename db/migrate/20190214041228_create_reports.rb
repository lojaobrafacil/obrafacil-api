class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.string :name
      t.string :attachment
      t.references :employee, foreign_key: true

      t.timestamps
    end
  end
end
