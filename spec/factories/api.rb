FactoryBot.define do
  factory :api do
    name { Faker::Name.name }
    federal_registration { Faker::Code.isbn }
    kind { "admin" }
  end
end
