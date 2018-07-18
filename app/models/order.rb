class Order < ApplicationRecord
  belongs_to :price_percentage, optional: true
  belongs_to :employee, optional: true
  belongs_to :cashier, optional: true
  belongs_to :client, optional: true
  belongs_to :carrier, optional: true
  belongs_to :company, optional: true
  # has_many :order_payments, dependent: :destroy
  # has_many :payment_methods, through: :order_payments
  # has_one :order_partner, dependent: :destroy
  # has_one :partner, through: :order_partner
  validates_presence_of :kind
  enum kind: [:budget, :normal]

end