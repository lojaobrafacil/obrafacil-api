FactoryBot.define do
  factory :phone do
    phone { Faker::PhoneNumber.phone_number }
    phone_type_id { create(:phone_type).id }
    association :phonable, :factory => :client
  end
end
