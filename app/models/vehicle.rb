class Vehicle < ApplicationRecord
  validates_presence_of [:model, :brand]
end
