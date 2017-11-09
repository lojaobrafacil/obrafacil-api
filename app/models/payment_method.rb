class PaymentMethod < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name, case_sensitive: true
end
