class Address < ApplicationRecord
  belongs_to :address_type
  belongs_to :city
  belongs_to :addressable, polymorphic: true
  validates_presence_of [:street, :zipcode]
  # validates_format_of :zipcode, :with => /[0-9]+/i, on: :save
  validates_numericality_of :zipcode, only_integer: true
end
