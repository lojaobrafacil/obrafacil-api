FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    description { Faker::Commerce.material }
    ncm { Faker::Number.decimal(2) }
    icms { Faker::Number.decimal(2) }
    sku { Faker::Number.decimal(8) }
    sku_xml { Faker::Number.decimal(8) }
    ipi { Faker::Number.decimal(2) }
    cest { Faker::Number.decimal(2) }
    bar_code { Faker::Commerce.promotion_code }
    reduction { Faker::Number.decimal(2) }
    weight { Faker::Number.decimal(2) }
    height { Faker::Number.decimal(2) }
    width { Faker::Number.decimal(2) }
    length { Faker::Number.decimal(2) }
    color { Faker::Commerce.color }
    kind { [0,0,1,1,2,2].sample }
    active true
    unit_id { create(:unit).id }
    sub_category_id { create(:sub_category).id }
    supplier_id { create(:supplier).id }
  end
end
