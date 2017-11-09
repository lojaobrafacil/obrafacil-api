FactoryBot.define do
  factory :cashier_payment do
    cashier_id { create(:cashier).id }
    employee_id { create(:employee).id }
    value { Faker.Number.decimal(3) }
  end
end
