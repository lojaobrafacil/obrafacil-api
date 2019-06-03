class Log::Worker < ApplicationRecord
  validates_presence_of :name, :started_at
end
