class Commission < ApplicationRecord
  belongs_to :partner
  before_save :set_date, on: :create

  def set_date
    time = (self.order_date + 1.month).beginning_of_month
    while [0, 6].include?(time.wday)
      time = time + 1.day
    end
    time = time + 15.days
    while [0, 6].include?(time.wday)
      time = time + 1.day
    end
    self.sent_date = time + 12.hour
  end
end
