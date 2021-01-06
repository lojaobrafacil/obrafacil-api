class SubCategory < ApplicationRecord
  belongs_to :category
  has_many :products
  before_destroy :disassociate_products!, prepend: true
  validates_presence_of :name

  private

  def disassociate_products!
    self.products.update_all(sub_category: nil)
  end
end
