FactoryBot.define do
  factory :supplier do
    name { Faker::Name.name }
    fantasy_name { Faker::Name.name }
    federal_registration { 1 }
    state_registration { 1 }
    kind { [0,0,0,1,1,1].sample }
    birth_date { Faker::Date.birthday(18, 65) }
    tax_regime { [0,0,1,1,2,2].sample }
    description { Faker::Lorem.paragraph }
    billing_type_id { create(:billing_type).id }
    user_id { create(:user).id }
  end
end
