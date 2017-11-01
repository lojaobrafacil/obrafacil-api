FactoryBot.define do
  factory :city do
    name { Faker::FamilyGuy.character }
    capital false
    state
  end
end
