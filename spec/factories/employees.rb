FactoryBot.define do
  factory :employee do
    name { Faker::Name.name }
    federal_registration { Faker::Code.isbn }
    state_registration { Faker::Code.isbn }
    active { true }
    birth_date { Faker::Date.birthday(18, 65) }
    renewal_date { Faker::Date.forward(10000) }
    commission_percent { Faker::Number.decimal(1, 2) }
    description { Faker::Lorem.paragraph }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
    street { Faker::Address.street_name }
    neighborhood { Faker::Address.street_name }
    zipcode { Faker::Number.number(8) }
    number { Faker::Number.number(4) }
    city { create(:city) }
    password { "12345678" }
    password_confirmation { "12345678" }
  end
end
