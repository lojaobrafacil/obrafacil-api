FactoryBot.define do
    factory :commission do
      partner_id { create(:partner).id }
    end
end
  