class CreateIbpts < ActiveRecord::Migration[5.1]
  def change
    create_table :ibpts do |t|
      t.integer :code
      t.text :description
      t.float :national_aliquota
      t.float :international_aliquota

      t.timestamps
    end
  end
end
