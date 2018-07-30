FactoryBot.define do
  factory :price_percentage do
    margin { Faker::Number.decimal(2) }
    kind { Faker::Number.between(1, 5) }
  end
end
