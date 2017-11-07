FactoryBot.define do
  factory :sub_category do
    name { Faker::Commerce.department }
    category_id { create(:category).id }
  end
end
