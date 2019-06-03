class PartnerGroup < ApplicationRecord
  validates_presence_of :name
  has_many :partners
end
