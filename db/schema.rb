# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171109173249) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "address_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "addresses", force: :cascade do |t|
    t.string "street"
    t.string "neighborhood"
    t.string "zipcode"
    t.string "ibge"
    t.string "gia"
    t.string "complement"
    t.string "description"
    t.bigint "address_type_id"
    t.bigint "city_id"
    t.integer "addressable_id"
    t.string "addressable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_type_id"], name: "index_addresses_on_address_type_id"
    t.index ["city_id"], name: "index_addresses_on_city_id"
  end

  create_table "banks", force: :cascade do |t|
    t.integer "code"
    t.string "name"
    t.string "slug"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "billing_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "carriers", force: :cascade do |t|
    t.string "name"
    t.string "federal_tax_number"
    t.string "state_registration"
    t.integer "kind"
    t.text "description"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cashier_payments", force: :cascade do |t|
    t.bigint "cashier_id"
    t.bigint "payment_method_id"
    t.float "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cashier_id"], name: "index_cashier_payments_on_cashier_id"
    t.index ["payment_method_id"], name: "index_cashier_payments_on_payment_method_id"
  end

  create_table "cashiers", force: :cascade do |t|
    t.datetime "start_date"
    t.datetime "finish_date"
    t.bigint "employee_id"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_cashiers_on_employee_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cfops", force: :cascade do |t|
    t.integer "code"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.boolean "capital", default: false
    t.bigint "state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["state_id"], name: "index_cities_on_state_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "federal_tax_number"
    t.string "state_registration"
    t.string "international_registration"
    t.integer "kind"
    t.boolean "active", default: true
    t.datetime "birth_date"
    t.datetime "renewal_date"
    t.integer "tax_regime"
    t.text "description"
    t.string "order_description"
    t.float "limit"
    t.bigint "billing_type_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["billing_type_id"], name: "index_clients_on_billing_type_id"
    t.index ["user_id"], name: "index_clients_on_user_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "fantasy_name"
    t.string "federal_tax_number"
    t.string "state_registration"
    t.integer "kind"
    t.datetime "birth_date"
    t.integer "tax_regime"
    t.text "description"
    t.integer "invoice_sale"
    t.integer "invoice_return"
    t.integer "pis_percent"
    t.integer "confins_percent"
    t.integer "icmsn_percent"
    t.integer "between_states_percent"
    t.bigint "billing_type_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["billing_type_id"], name: "index_companies_on_billing_type_id"
    t.index ["user_id"], name: "index_companies_on_user_id"
  end

  create_table "email_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "emails", force: :cascade do |t|
    t.string "email"
    t.string "contact"
    t.integer "emailable_id"
    t.string "emailable_type"
    t.bigint "email_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_type_id"], name: "index_emails_on_email_type_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "name"
    t.string "federal_tax_number"
    t.string "state_registration"
    t.boolean "active", default: true
    t.datetime "birth_date"
    t.datetime "renewal_date"
    t.integer "commission_percent"
    t.text "description"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_employees_on_user_id"
  end

  create_table "employees_permissions", id: false, force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "permission_id"
    t.index ["employee_id"], name: "index_employees_permissions_on_employee_id"
    t.index ["permission_id"], name: "index_employees_permissions_on_permission_id"
  end

  create_table "ibpts", force: :cascade do |t|
    t.integer "code"
    t.text "description"
    t.float "national_aliquota"
    t.float "international_aliquota"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer "kind"
    t.datetime "exclusion_date"
    t.text "description"
    t.float "discont"
    t.float "freight"
    t.datetime "billing_date"
    t.string "file"
    t.bigint "price_percentage_id"
    t.bigint "employee_id"
    t.bigint "cashier_id"
    t.bigint "client_id"
    t.bigint "carrier_id"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["carrier_id"], name: "index_orders_on_carrier_id"
    t.index ["cashier_id"], name: "index_orders_on_cashier_id"
    t.index ["client_id"], name: "index_orders_on_client_id"
    t.index ["company_id"], name: "index_orders_on_company_id"
    t.index ["employee_id"], name: "index_orders_on_employee_id"
    t.index ["price_percentage_id"], name: "index_orders_on_price_percentage_id"
  end

  create_table "partners", force: :cascade do |t|
    t.string "name"
    t.string "federal_tax_number"
    t.string "state_registration"
    t.string "international_registration"
    t.integer "kind"
    t.boolean "active", default: true
    t.datetime "birth_date"
    t.datetime "renewal_date"
    t.integer "tax_regime"
    t.text "description"
    t.string "order_description"
    t.float "limit"
    t.integer "origin"
    t.integer "percent"
    t.string "agency"
    t.string "account"
    t.string "favored"
    t.bigint "bank_id"
    t.bigint "billing_type_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_id"], name: "index_partners_on_bank_id"
    t.index ["billing_type_id"], name: "index_partners_on_billing_type_id"
    t.index ["user_id"], name: "index_partners_on_user_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "phone_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "phones", force: :cascade do |t|
    t.string "phone"
    t.string "contact"
    t.integer "phonable_id"
    t.string "phonable_type"
    t.bigint "phone_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["phone_type_id"], name: "index_phones_on_phone_type_id"
  end

  create_table "price_percentages", force: :cascade do |t|
    t.float "margin"
    t.integer "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prices", force: :cascade do |t|
    t.float "price"
    t.float "margin"
    t.integer "kind"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_prices_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "common_nomenclature_mercosur"
    t.float "added_value_tax"
    t.string "brand"
    t.float "cost"
    t.float "tax_industrialized_products"
    t.float "profit_margin"
    t.integer "stock"
    t.integer "stock_min"
    t.integer "stock_max"
    t.datetime "stock_date"
    t.float "aliquot_merchandise_tax"
    t.string "bar_code"
    t.float "tax_substitution"
    t.float "tax_reduction"
    t.float "discount"
    t.float "weight"
    t.float "height"
    t.float "width"
    t.float "length"
    t.string "color"
    t.string "code_tax_substitution_specification"
    t.integer "kind"
    t.boolean "active", default: true
    t.bigint "sub_category_id"
    t.bigint "unit_id"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_products_on_company_id"
    t.index ["sub_category_id"], name: "index_products_on_sub_category_id"
    t.index ["unit_id"], name: "index_products_on_unit_id"
  end

  create_table "providers", force: :cascade do |t|
    t.string "name"
    t.string "fantasy_name"
    t.string "federal_tax_number"
    t.string "state_registration"
    t.integer "kind"
    t.datetime "birth_date"
    t.integer "tax_regime"
    t.text "description"
    t.integer "invoice_sale"
    t.integer "invoice_return"
    t.integer "pis_percent"
    t.integer "confins_percent"
    t.integer "icmsn_percent"
    t.integer "between_states_percent"
    t.bigint "billing_type_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["billing_type_id"], name: "index_providers_on_billing_type_id"
    t.index ["user_id"], name: "index_providers_on_user_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.string "acronym"
    t.bigint "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_states_on_region_id"
  end

  create_table "sub_categories", force: :cascade do |t|
    t.string "name"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_sub_categories_on_category_id"
  end

  create_table "units", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auth_token"
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "addresses", "address_types"
  add_foreign_key "addresses", "cities"
  add_foreign_key "cashier_payments", "cashiers"
  add_foreign_key "cashier_payments", "payment_methods"
  add_foreign_key "cashiers", "employees"
  add_foreign_key "cities", "states"
  add_foreign_key "clients", "billing_types"
  add_foreign_key "clients", "users"
  add_foreign_key "companies", "billing_types"
  add_foreign_key "companies", "users"
  add_foreign_key "emails", "email_types"
  add_foreign_key "employees", "users"
  add_foreign_key "orders", "carriers"
  add_foreign_key "orders", "cashiers"
  add_foreign_key "orders", "clients"
  add_foreign_key "orders", "companies"
  add_foreign_key "orders", "employees"
  add_foreign_key "orders", "price_percentages"
  add_foreign_key "partners", "banks"
  add_foreign_key "partners", "billing_types"
  add_foreign_key "partners", "users"
  add_foreign_key "phones", "phone_types"
  add_foreign_key "prices", "products"
  add_foreign_key "products", "companies"
  add_foreign_key "products", "sub_categories"
  add_foreign_key "products", "units"
  add_foreign_key "providers", "billing_types"
  add_foreign_key "providers", "users"
  add_foreign_key "states", "regions"
  add_foreign_key "sub_categories", "categories"
end
