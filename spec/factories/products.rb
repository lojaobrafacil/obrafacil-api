FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    description { Faker::Commerce.material }
    common_nomenclature_mercosur { Faker::Number.decimal(2) }
    added_value_tax { Faker::Number.decimal(2) }
    brand { Faker::Commerce.department }
    cost { Faker::Commerce.price }
    tax_industrialized_products { Faker::Number.decimal(2) }
    profit_margin { Faker::Number.decimal(2) }
    aliquot_merchandise_tax { Faker::Number.decimal(2) }
    bar_code { Faker::Commerce.promotion_code }
    tax_substitution { Faker::Number.decimal(2) }
    tax_reduction { Faker::Number.decimal(2) }
    discount { Faker::Number.decimal(2) }
    weight { Faker::Number.decimal(2) }
    height { Faker::Number.decimal(2) }
    width { Faker::Number.decimal(2) }
    length { Faker::Number.decimal(2) }
    color { Faker::Commerce.color }
    code_tax_substitution_specification { Faker::Number.decimal(2) }
    kind { [0,0,1,1,2,2].sample }
    active true
    unit_id { create(:unit).id }
    sub_category_id { create(:sub_category).id }
  end
end
