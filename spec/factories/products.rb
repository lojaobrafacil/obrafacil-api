FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    description { Faker::Commerce.material }
    sku { Faker::Number.number(digits: 8) }
    sku_xml { Faker::Number.number(digits: 8) }
    ipi { Faker::Number.decimal(l_digits: 2) }
    barcode { Faker::Commerce.promotion_code }
    reduction { Faker::Number.decimal(l_digits: 2) }
    weight { Faker::Number.decimal(l_digits: 2) }
    height { Faker::Number.decimal(l_digits: 2) }
    width { Faker::Number.decimal(l_digits: 2) }
    length { Faker::Number.decimal(l_digits: 2) }
    color { Faker::Commerce.color }
    kind { Product.kinds.keys.sample }
    status { Product.statuses.keys.sample }
    unit_id { create(:unit).id }
    sub_category_id { create(:sub_category).id }
    supplier_id { create(:supplier).id }
  end
end
