FactoryBot.define do
  factory :log_coupon, class: Log::Coupon do
    external_order_id { Faker::Number.number(4) }
    client_federal_registration { Faker::Number.number(11) }
  end
end
