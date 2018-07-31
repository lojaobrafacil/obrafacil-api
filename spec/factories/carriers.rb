FactoryBot.define do
  factory :carrier do
    name { Faker::Name.name }
    federal_registration { Faker::Code.isbn }
    state_registration { Faker::Code.isbn }
    kind { [0,0,0,1,1,1].sample }
    description { Faker::Lorem.sentence }
    active { true }
  end
end
