FactoryBot.define do
  factory :partner do
    name { Faker::Name.name }
    federal_registration { Faker::Code.isbn }
    state_registration { Faker::Code.isbn }
    kind { ["physical", "legal"].sample }
    status { "active" }
    birthday { Faker::Date.birthday(min_age: 18, max_age: 65) }
    renewal_date { Faker::Date.forward(days: 1000) }
    description { Faker::Lorem.paragraph }
    ocupation { Faker::Lorem.paragraph }
    origin { ["shop", "internet", "relationship", "nivaldo"].sample }
    percent { Faker::Number.decimal(l_digits: 0, r_digits: 2) }
    agency { Faker::Number.number(digits: 4) }
    account { Faker::Number.number(digits: 7) }
    favored { Faker::Name.name }
    favored_federal_registration { Faker::Code.isbn }
    bank_id { create(:bank).id }
    partner_group_id { create(:partner_group).id }
    created_by_id { create(:employee).id }
    coupon { create(:coupon) }
    emails { build_list :email, 3 }
    phones { build_list :phone, 3 }
    addresses { build_list :address, 3 }
  end
end
