class Cashier < ApplicationRecord
  has_many :cashier_payments, dependent: :destroy
  has_many :payment_methods, through: :cashier_payments
  accepts_nested_attributes_for :cashier_payments, allow_destroy: true
  belongs_to :employee, optional: true
  validates_presence_of [:start_date, :finish_date]
  validates_uniqueness_of [:start_date, :finish_date]

  def self.active; where("active = true").order(:id); end
  def self.inactive; where("active = false").order(:id); end
end
