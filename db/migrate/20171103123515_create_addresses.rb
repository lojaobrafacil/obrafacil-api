class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :neighborhood
      t.string :zipcode
      t.string :ibge
      t.string :gia
      t.string :complement
      t.string :description
      t.references :address_type, foreign_key: true
      t.references :city, foreign_key: true
      t.integer :addressable_id
      t.string :addressable_type

      t.timestamps
    end
  end
end
