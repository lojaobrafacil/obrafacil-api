FactoryBot.define do
  factory :partner do
    name { Faker::Name.name }
    federal_registration { Faker::Code.isbn }
    state_registration { Faker::Code.isbn }
    kind { [0,0,0,1,1,1].sample }
    active { true }
    started_date { Faker::Date.birthday(18, 65) }
    renewal_date { Faker::Date.forward(10000) }
    description { Faker::Lorem.paragraph }
    ocupation { Faker::Lorem.paragraph }
    origin { [0,0,1,1,2,2].sample }
    percent { Faker::Number.decimal(0, 2) }
    agency { Faker::Number.number(4) }
    account { Faker::Number.number(7) }
    favored { Faker::Name.name }
    bank_id { create(:bank).id }
  end
end
