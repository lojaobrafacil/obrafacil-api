class AddNumberToAddress < ActiveRecord::Migration[5.1]
  def change
    add_column :addresses, :number, :string
    remove_column :addresses, :gia
  end
end
