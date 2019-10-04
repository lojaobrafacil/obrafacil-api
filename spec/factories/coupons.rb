FactoryBot.define do
  factory :coupon do
    name { Faker::Name.name }
    discount { Faker::Number.decimal(l_digits: 2) }
    status { 1 }
    kind { 0 }
    expired_at { DateTime.now + 1.year }
    starts_at { DateTime.now }
    total_uses { Faker::Number.number(digits: 2) }
    client_uses { Faker::Number.number(digits: 2) }
    description { Faker::Lorem.paragraph }
  end
end
