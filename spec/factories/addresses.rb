FactoryBot.define do
  factory :address do
    street { Faker::Address.street_name }
    neighborhood { Faker::Address.street_name }
    zipcode { Faker::Address.zip_code }
    ibge { Faker::Number.number(8) }
    gia { Faker::Number.number(8) }
    complement { Faker::Address.building_number }
    description { Faker::Lorem.paragraph }
    address_type_id { create(:address_type).id }
    city_id { create(:city).id }
    association :addressable, :factory => :client
  end
end
