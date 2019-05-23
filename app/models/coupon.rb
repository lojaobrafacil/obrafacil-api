class Coupon < ApplicationRecord
  validates_presence_of :name, :code, :kind, :status, :starts_at, :expired_at
  enum kind: [:percent, :value]
  enum status: [:inactive, :active]
  before_validation :generate_code, on: :create

  def generate_code
    self.code = SecureRandom.hex(3).upcase
  end
end
