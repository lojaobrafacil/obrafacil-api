FactoryBot.define do
  factory :employee do
    name { Faker::Name.name }
    federal_tax_number { Faker::Code.isbn }
    state_registration { Faker::Code.isbn }
    active { true }
    birth_date { Faker::Date.birthday(18, 65) }
    renewal_date { Faker::Date.forward(10000) }
    commission_percent { Faker::Number.decimal(1,2) }
    description { Faker::Lorem.paragraph }
    user_id { create(:user).id }
  end
end
