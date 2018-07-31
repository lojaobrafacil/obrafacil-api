FactoryBot.define do
  factory :client do
    name { Faker::Name.name }
    federal_registration { Faker::Code.isbn }
    state_registration { Faker::Code.isbn }
    international_registration { Faker::Code.isbn }
    kind { [0,0,0,1,1,1].sample }
    active { true }
    birth_date { Faker::Date.birthday(18, 65) }
    renewal_date { Faker::Date.forward(10000) }
    tax_regime { [0,0,1,1,2,2].sample }
    description { Faker::Lorem.paragraph }
    order_description { Faker::Lorem.paragraph }
    limit { Faker::Number.decimal(2) }
    billing_type_id { create(:billing_type).id }
    user_id { create(:user).id }
  end
end
