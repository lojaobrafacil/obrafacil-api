class Address < ApplicationRecord
  belongs_to :address_type
  belongs_to :city
  belongs_to :addressable, polymorphic: true
  validates_presence_of :street, :zipcode
  validates_numericality_of :zipcode, only_integer: true

  def partner
    self.emailable_type == "Partner" ? self.emailable : nil
  end

  def client
    self.emailable_type == "Client" ? self.emailable : nil
  end
end
