FactoryBot.define do
  factory :address_type_v2, :class => V2::Admin do
    name { Faker::FamilyGuy.character }
  end
end
