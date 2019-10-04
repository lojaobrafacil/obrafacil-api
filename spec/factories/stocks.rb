FactoryBot.define do
  factory :stock do
    stock { Faker::Number.number(3) }
    stock_min { Faker::Number.number(1) }
    stock_max { Faker::Number.number(4) }
    product_id { create(:product).id }
    company_id { create(:company).id }
  end
end
