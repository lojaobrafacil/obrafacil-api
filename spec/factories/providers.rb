FactoryBot.define do
  factory :provider do
    name { Faker::Name.name }
    fantasy_name { Faker::Name.name }
    federal_tax_number { 1 }
    state_registration { 1 }
    kind { [0,0,0,1,1,1].sample }
    birth_date { Faker::Date.birthday(18, 65) }
    tax_regime { [0,0,1,1,2,2].sample }
    description { Faker::Lorem.paragraph }
    invoice_sale { 1 }
    invoice_return { 1 }
    pis_percent { 1 }
    confins_percent { 1 }
    icmsn_percent { 1 }
    between_states_percent { 1 }
    billing_type_id { create(:billing_type).id }
    user_id { create(:user).id }
  end
end
