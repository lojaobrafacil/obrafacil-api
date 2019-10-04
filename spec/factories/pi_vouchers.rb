FactoryBot.define do
  factory :pi_voucher do
    received_at { Time.now }
    value { Faker::Number.decimal(l_digits: 2) }
    company { create(:company) }
    partner { create(:partner) }
  end
end
