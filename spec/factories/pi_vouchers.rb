FactoryBot.define do
  factory :pi_voucher do
    received_at { Time.now }
    value { Faker::Number.number(4) }
    company_id { create(:company).id }
    partner_id { create(:partner).id }
  end
end
