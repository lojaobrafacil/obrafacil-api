class CreateCashiers < ActiveRecord::Migration[5.1]
  def change
    create_table :cashiers do |t|
      t.datetime :start_date
      t.datetime :finish_date
      t.references :employee, foreign_key: true
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
