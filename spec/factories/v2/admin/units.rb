FactoryBot.define do
  factory :unit do
    name { Faker::Commerce.department }
    description { Faker::Commerce.product_name }
  end
end
