class PiVoucher < ApplicationRecord
  belongs_to :company, optional: true
  belongs_to :partner
  validates_presence_of :expiration_date, :value, :status
  after_initialize :default_values

  enum status: [:used, :active, :inactive]

  private

  def default_values
    self.expiration_date = Time.now + 30.days
  end
end
