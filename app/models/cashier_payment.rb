class CashierPayment < ApplicationRecord
  belongs_to :cashier
  belongs_to :payment_method
  validates_presence_of :value
  validates_numericality_of :value
end
