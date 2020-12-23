class Margin < ApplicationRecord
  after_create :generate_prices

  def generate_prices
    products = Product.all
    if !products.empty?
      products.each do |prod|
        prod.prices.create(name: "tabela #{self.order}", value: 1, plataform: 1, margin: self)
      end
    end
  end
end
