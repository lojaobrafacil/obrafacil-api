FactoryBot.define do
  factory :price_percentage do
    company_id { create(:company).id }
    margin { Faker::Number.decimal(l_digits: 2) }
    kind { Faker::Number.between(from: 1, to: 5) }
  end
end
