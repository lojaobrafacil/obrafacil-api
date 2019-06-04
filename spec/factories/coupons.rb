FactoryBot.define do
  factory :coupon do
    name { Faker::Name.name }
    discount { Faker::Number.decimal(1,0) }
    status { 1 }
    kind { 0 }
    max_value { Faker::Number.decimal(3, 0) }
    expired_at { DateTime.now + 1.year }
    starts_at { DateTime.now }
    total_uses { Faker::Number.number(2) }
    client_uses { Faker::Number.number(2) }
    shipping { false }
    logged { false }
    description { Faker::Lorem.paragraph }
  end
end