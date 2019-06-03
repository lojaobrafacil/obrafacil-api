class AddPhoneAndAddressToEmployee < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :celphone, :string
    add_column :employees, :phone, :string
    add_column :employees, :street, :string
    add_column :employees, :neighborhood, :string
    add_column :employees, :zipcode, :string
    add_column :employees, :complement, :string
    add_column :employees, :number, :string
    add_reference :employees, :city, foreign_key: true
  end
end
