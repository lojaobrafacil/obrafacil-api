FactoryBot.define do
  factory :employee do
    name { Faker::Name.name }
    federal_registration { Faker::Code.isbn }
    state_registration { Faker::Code.isbn }
    active { true }
    birth_date { Faker::Date.birthday(min_age: 18, max_age: 65) }
    renewal_date { Faker::Date.forward(days: 1000) }
    commission_percent { Faker::Number.decimal(l_digits: 1, r_digits: 2) }
    description { Faker::Lorem.paragraph }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
    street { Faker::Address.street_name }
    neighborhood { Faker::Address.street_name }
    zipcode { Faker::Number.number(digits: 8) }
    number { Faker::Number.number(digits: 4) }
    city { create(:city) }
    password { "12345678" }
    password_confirmation { "12345678" }
  end
end
