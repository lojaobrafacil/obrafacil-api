class CreatePhones < ActiveRecord::Migration[5.1]
  def change
    create_table :phones do |t|
      t.string :phone
      t.string :contact
      t.integer :phonable_id
      t.string :phonable_type
      t.references :phone_type, foreign_key: true

      t.timestamps
    end
  end
end
