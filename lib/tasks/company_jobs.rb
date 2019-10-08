class CompanyJobs
  def generate_stocks(id)
    products = Product.all
    if !products.empty?
      products.each do |product|
        product.stocks.create(stock: 0, stock_min: 0, stock_max: 0, company_id: id)
      end
    end
  end
end
