class Price < ApplicationRecord
  belongs_to :product
  belongs_to :margin, optional: Proc.new { |price| !!price.value }
  enum plataform: { shop: 1, site: 2 }
  before_save :calculate_price

  def calculate_price
    if self.margin
      self.value = (((((((self.product.cost * (1 + (self.product.supplier_discount / 100))) + self.product.freight) * (1 + (self.product.ipi / 100))) * (1 + (self.product.st / 100))) / (1 - (self.product.contribution_margin / 100)))) * self.margin.value).round(2)
    end
  end
end
