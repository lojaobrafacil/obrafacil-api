FactoryBot.define do
  factory :order do
    kind { ["budget", "normal"].sample }
    exclusion_date { nil }
    description { Faker::Lorem.sentence }
    discount { Faker::Number.decimal(l_digits: 2) }
    freight { Faker::Number.decimal(l_digits: 2) }
    billing_date { Faker::Date.backward(days: 10) }
    file { Faker::File.file_name(dir: "path/to") }
    selected_margin { [1, 2, 3, 4, 5].sample }
    employee_id { create(:employee).id }
    cashier_id { create(:cashier).id }
    client_id { create(:client).id }
    carrier_id { create(:carrier).id }
    company_id { create(:company).id }
  end
end
