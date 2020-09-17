class Commission < ApplicationRecord
  belongs_to :partner
  before_save :set_date, on: :create

  def set_date
    time = (self.order_date + 1.month).beginning_of_month + 13.day
    self.sent_date = time + 12.hour
  end
end
