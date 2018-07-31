FactoryBot.define do
  factory :employee do
    name { Faker::Name.name }
    federal_registration { Faker::Code.isbn }
    state_registration { Faker::Code.isbn }
    active { true }
    birth_date { Faker::Date.birthday(18, 65) }
    renewal_date { Faker::Date.forward(10000) }
    commission_percent { Faker::Number.decimal(1,2) }
    description { Faker::Lorem.paragraph }
		email { Faker::Internet.email }
		password '12345678'
		password_confirmation '12345678'
  end
end
