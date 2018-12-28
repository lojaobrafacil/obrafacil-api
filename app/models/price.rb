class Price < ApplicationRecord
  validates_numericality_of :kind, greater_than_or_equal_to: 1, less_than_or_equal_to: 10, only_integer: true
  validates_uniqueness_of :company_product_id, :scope => [:kind]
  belongs_to :company_product
  # after_create :generate_margins!
  #
  # def generate_margins!
  #   self.update(margin: (self.price.to_f-self.product.cost.to_f)/100)
  # end
end
