class Log::Worker < ApplicationRecord
  validates_presence_of :name, :started_at
  before_validation :set_started_at_to_now

  def set_started_at_to_now
    self.started_at = Time.now
  end
end
