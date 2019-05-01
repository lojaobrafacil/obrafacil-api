class AddPhoneAndAddressToEmployee < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :celphone, :string
    add_column :employees, :phone, :string
    add_column :employees, :street, :string
    add_column :employees, :neighborhood, :string
    add_column :employees, :zipcode, :string
    add_column :employees, :complement, :string
    add_column :employees, :number, :string
    add_column :employees, :city, :string
    add_column :employees, :state, :string
  end
end
