class PiVoucher < ApplicationRecord
  belongs_to :company, optional: true
  belongs_to :partner
  validates_presence_of :expiration_date, :value, :status

  enum status: [:used, :active, :inactive]

  def expiration
    expiration_date = Time.now + 30.days
  end
end
