FactoryBot.define do
  factory :price do
    margin { Faker::Number.decimal(l_digits: 2) }
    kind { [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10].sample }
    stock_id { create(:stock).id }
  end
end
