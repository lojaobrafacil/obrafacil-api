class CreateApis < ActiveRecord::Migration[5.2]
  def change
    create_table :apis do |t|
      t.string :name
      t.string :federal_registration
      t.string :access_id
      t.string :access_key
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
