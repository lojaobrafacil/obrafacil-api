class Coupon < ApplicationRecord
  validates_presence_of :name, :code, :discount, :kind, :status, :starts_at, :expired_at
  enum kind: [:percent, :value]
  enum status: [:inactive, :active]
  before_validation :default_values, on: :create
  belongs_to :partner, optional: true

  def default_values
    self.code ||= generate_code
    self.shipping ||= false
    self.logged ||= false
    self.total_uses ||= 0
    self.client_uses ||= 0
    self.max_value ||= 0
  end

  private

  def generate_code
    code = SecureRandom.hex(3).upcase
    Coupon.find_by(code: code) ? generate_code : code
  end
end
