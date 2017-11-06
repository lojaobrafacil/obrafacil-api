class Phone < ApplicationRecord
  belongs_to :phone_type
  belongs_to :phonable, polymorphic: true
  validates_presence_of :phone
end
