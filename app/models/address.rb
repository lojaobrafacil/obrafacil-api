class Address < ApplicationRecord
  belongs_to :address_type
  belongs_to :city

  validates_presence_of :street, :neighborhood, :zipcode
end
