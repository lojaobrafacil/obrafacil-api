FactoryBot.define do
  factory :supplier do
    name { Faker::Name.name }
    fantasy_name { Faker::Name.name }
    federal_registration { 1 }
    state_registration { 1 }
    birth_date { Faker::Date.birthday(min_age: 18, max_age: 65) }
    tax_regime { ["simple", "normal", "presumed"].sample }
    description { Faker::Lorem.paragraph }
    billing_type_id { create(:billing_type).id }
  end
end
