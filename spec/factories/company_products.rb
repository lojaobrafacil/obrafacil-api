FactoryBot.define do
  factory :company_product do
    stock { Faker::Number.number(3) }
    stock_min { Faker::Number.number(1) }
    stock_max { Faker::Number.number(4) }
    stock_date { Faker::Date.between(10.days.ago, Date.today) }
    product_id { create(:product).id }
    company_id { create(:company).id }
  end
end
