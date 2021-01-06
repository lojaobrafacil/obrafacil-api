class PaymentTerm < ApplicationRecord
  has_many :orders
end
