class Stock < ApplicationRecord
  belongs_to :company
  belongs_to :product
  has_many :prices
  accepts_nested_attributes_for :prices, allow_destroy: true
  validates_presence_of [:stock, :stock_max, :stock_min]
  before_save :internal_code

  def internal_code
    self.code |= self.product.id
  end
end
