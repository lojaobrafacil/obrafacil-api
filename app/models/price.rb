class Price < ApplicationRecord
  validates_numericality_of :kind, greater_than_or_equal_to: 1, less_than_or_equal_to: 10, only_integer: true
  validates_uniqueness_of :stock_id, :scope => [:kind]
  belongs_to :stock
  # after_create :generate_margins!
  #
  # def generate_margins!
  #   self.update(margin: (self.price.to_f-self.product.cost.to_f)/100)
  # end
end
