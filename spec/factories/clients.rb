FactoryBot.define do
  factory :client do
    name { Faker::Name.name }
    federal_registration { Faker::Code.isbn }
    state_registration { Faker::Code.isbn }
    international_registration { Faker::Code.isbn }
    kind { ["physical", "legal"].sample }
    status { "active" }
    birthday { Faker::Date.birthday(min_age: 18, max_age: 65) }
    renewal_date { Faker::Date.forward(days: 1000) }
    tax_regime { ["simple", "normal", "presumed"].sample }
    description { Faker::Lorem.paragraph }
    order_description { Faker::Lorem.paragraph }
    limit { Faker::Number.decimal(l_digits: 2) }
    billing_type_id { create(:billing_type).id }
  end
end
