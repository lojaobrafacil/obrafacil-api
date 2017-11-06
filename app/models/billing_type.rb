class BillingType < ApplicationRecord
  has_many :clients
  has_many :partners
  validates_presence_of :name
end
