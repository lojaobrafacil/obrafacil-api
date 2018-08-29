class CompanyJobs

  def generate_price_percentages(id)
    company = Company.find(id)
    (1..5).each do |kind|
      company.price_percentages.create(kind: kind, margin: 0.0)
    end
  end

  def generate_stocks(id)
    products = Product.all
    if !products.empty?
      products.each do |product|
        product.company_products.create(stock: 0, stock_min: 0, stock_max: 0, company_id: id)
      end
    end
  end

end