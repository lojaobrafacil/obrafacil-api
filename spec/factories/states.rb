FactoryBot.define do
  factory :state do
    name { Faker::Address.state }
    acronym { Faker::Address.state_abbr }
    region_id { create(:region).id }
  end
end
