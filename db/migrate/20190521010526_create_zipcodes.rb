class CreateZipcodes < ActiveRecord::Migration[5.2]
  def change
    create_table :zipcodes do |t|
      t.integer :code
      t.string :place
      t.string :neighborhood
      t.references :city, foreign_key: true
      t.string :ibge
      t.string :gia

      t.timestamps
    end
  end
end
