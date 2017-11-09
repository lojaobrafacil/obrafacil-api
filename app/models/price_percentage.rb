class PricePercentage < ApplicationRecord
  validates_numericality_of :kind, greater_than_or_equal_to:1, less_than_or_equal_to: 5, only_integer:true
  validates_uniqueness_of :kind
  validates_presence_of :margin
end
