class BillingType < ApplicationRecord
  has_many :clients
  validates_presence_of :name
end
