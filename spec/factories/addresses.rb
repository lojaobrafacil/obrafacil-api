FactoryBot.define do
  factory :address do
    street { Faker::Address.street_name }
    neighborhood { Faker::Address.street_name }
    zipcode { Faker::Number.number(digits: 8) }
    ibge { Faker::Number.number(digits: 8) }
    number { Faker::Number.number(digits: 4) }
    complement { Faker::Address.building_number }
    description { Faker::Lorem.paragraph }
    address_type_id { create(:address_type).id }
    city_id { create(:city).id }
    association :addressable, factory: :client
  end
end
