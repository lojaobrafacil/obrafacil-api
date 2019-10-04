FactoryBot.define do
  factory :ibpt do
    code { Faker::Number.number(digits: 3) }
    description { Faker::Lorem.sentence }
    national_aliquota { Faker::Code.isbn }
    international_aliquota { Faker::Code.isbn }
  end
end
