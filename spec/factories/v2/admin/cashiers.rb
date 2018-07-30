FactoryBot.define do
  factory :cashier do
    start_date { Faker::Date.unique.backward(1004) }
    finish_date { Faker::Date.unique.backward(1004) }
    employee_id { create(:employee).id }
    active { true }
  end
end
