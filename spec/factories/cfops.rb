FactoryBot.define do
  factory :cfop do
    code { Faker::Number.number(digits: 3) }
    description { Faker::Lorem.sentence }
  end
end
