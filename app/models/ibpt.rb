class Ibpt < ApplicationRecord
  validates_presence_of [:code, :national_aliquota, :international_aliquota]
end
