FactoryBot.define do
  factory :stock do
    stock { Faker::Number.number(digits: 3) }
    stock_min { Faker::Number.number(digits: 1) }
    stock_max { Faker::Number.number(digits: 4) }
    product_id { create(:product).id }
    company_id { create(:company).id }
  end
end
