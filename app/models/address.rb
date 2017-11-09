class Address < ApplicationRecord
  belongs_to :address_type
  belongs_to :city
  belongs_to :addressable, polymorphic: true
  validates_presence_of [:street, :zipcode]
end
