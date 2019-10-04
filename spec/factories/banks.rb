FactoryBot.define do
  factory :bank do
    code { Faker::Number.number(digits: 4) }
    name { Faker::Bank.name }
    slug { Faker::Bank.name }
    description { Faker::Lorem.paragraph }
  end
end
