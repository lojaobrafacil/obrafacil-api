class Commission < ApplicationRecord
  default_scope { where(deleted_at: nil) }
  belongs_to :partner
  before_save :set_date, on: :create

  def set_date
    time = (self.order_date + 1.month).beginning_of_month + 15.day
    self.sent_date = time + 12.hour
  end
end
