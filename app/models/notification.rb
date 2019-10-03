class Notification < ApplicationRecord
  validates_presence_of :title, :notified_id, :notified_type
  belongs_to :notified, polymorphic: true
  belongs_to :target, polymorphic: true
end
