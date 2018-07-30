FactoryBot.define do
  factory :price_percentage do
    margin { Faker::Number.decimal(2) }
    kind { Faker::Number.between(1, 5) }
    company_id { create(:company).id }
  end
end
