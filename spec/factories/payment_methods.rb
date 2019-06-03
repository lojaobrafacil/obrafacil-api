FactoryBot.define do
  factory :payment_method do
    name { Faker::Name.name }
  end
end
