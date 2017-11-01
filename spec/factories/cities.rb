FactoryBot.define do
  factory :city do
    name { Faker::Name.first_name }
    capital { Faker::Boolean.boolean }
    state_id { create(:state).id }
  end
end
