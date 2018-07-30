FactoryBot.define do
  factory :cfop do
    code { Faker::Number.number(3) }
    description { Faker::Lorem.sentence }
  end
end
