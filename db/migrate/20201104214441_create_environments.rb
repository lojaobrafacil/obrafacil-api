class CreateEnvironments < ActiveRecord::Migration[5.2]
  def up
    create_table :environments do |t|
      t.string :name

      t.timestamps
    end
    add_reference :order_items, :environment, foreign_key: true
    add_column :order_items, :environment_complement, :string
  end

  def down
    remove_column :order_items, :environments_id
    remove_column :order_items, :environment_complement
    drop_table :environments
  end
end
