class DeviseTokenAuthCreateEmployees < ActiveRecord::Migration[5.1]
  def change
    create_table(:employees) do |t|
      ## Required
      t.string :provider, :null => false, :default => "email"
      t.string :uid, :null => false, :default => ""

      ## Tokens
      t.json :tokens

      t.timestamps
    end

    add_index :employees, [:uid, :provider],     unique: true
  end
end
