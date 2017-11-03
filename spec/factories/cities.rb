FactoryBot.define do
  factory :city do
    name { Faker::Address.city }
    capital { Faker::Boolean.boolean }
    state_id { create(:state).id }
  end
end
