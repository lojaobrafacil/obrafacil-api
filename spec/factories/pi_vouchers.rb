FactoryBot.define do
  factory :pi_voucher do
    received_at { Time.now }
    value { Faker::Number.number(4) }
    association :company
    association :partner
  end
end
