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

ActiveRecord::Schema.define(version: 2020_06_24_145807) do

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
    t.string "complement"
    t.string "description"
    t.bigint "address_type_id"
    t.bigint "city_id"
    t.integer "addressable_id"
    t.string "addressable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "number"
    t.index ["address_type_id"], name: "index_addresses_on_address_type_id"
    t.index ["city_id"], name: "index_addresses_on_city_id"
  end

  create_table "apis", force: :cascade do |t|
    t.string "name"
    t.string "federal_registration"
    t.string "access_id"
    t.string "access_key"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kind", default: 1
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
    t.string "federal_registration"
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
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "employee_id"
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
    t.string "searcher"
    t.index ["state_id"], name: "index_cities_on_state_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "federal_registration"
    t.string "state_registration"
    t.string "international_registration"
    t.integer "kind"
    t.datetime "renewal_date"
    t.integer "tax_regime"
    t.text "description"
    t.string "order_description"
    t.float "limit"
    t.bigint "billing_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "image"
    t.string "email"
    t.json "tokens"
    t.integer "status"
    t.datetime "birthday"
    t.integer "limit_margin", default: 1
    t.string "searcher"
    t.index ["billing_type_id"], name: "index_clients_on_billing_type_id"
    t.index ["confirmation_token"], name: "index_clients_on_confirmation_token", unique: true
    t.index ["email"], name: "index_clients_on_email", unique: true
    t.index ["reset_password_token"], name: "index_clients_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_clients_on_uid_and_provider", unique: true
  end

  create_table "commissions", force: :cascade do |t|
    t.bigint "partner_id"
    t.integer "order_id"
    t.datetime "order_date"
    t.float "order_price"
    t.string "client_name"
    t.integer "points"
    t.float "percent"
    t.datetime "percent_date"
    t.datetime "sent_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "return_price"
    t.index ["partner_id"], name: "index_commissions_on_partner_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "fantasy_name"
    t.string "federal_registration"
    t.string "state_registration"
    t.datetime "birth_date"
    t.integer "tax_regime"
    t.text "description"
    t.integer "invoice_sale"
    t.integer "invoice_return"
    t.integer "pis_percent"
    t.integer "confins_percent"
    t.integer "icmsn_percent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "margins"
  end

  create_table "coupons", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.float "discount"
    t.integer "status"
    t.integer "kind"
    t.datetime "expired_at"
    t.datetime "starts_at"
    t.integer "total_uses"
    t.integer "client_uses"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "partner_id"
    t.index ["partner_id"], name: "index_coupons_on_partner_id"
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
    t.boolean "primary", default: false
    t.index ["email_type_id"], name: "index_emails_on_email_type_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "name"
    t.string "federal_registration"
    t.string "state_registration"
    t.boolean "active", default: true
    t.datetime "birth_date"
    t.datetime "renewal_date"
    t.float "commission_percent"
    t.text "description"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.boolean "change_partners", default: false
    t.boolean "change_clients", default: false
    t.boolean "order_creation", default: false
    t.integer "limit_margin", default: 3
    t.boolean "change_cashiers", default: false
    t.boolean "change_suppliers", default: false
    t.boolean "generate_nfe", default: false
    t.boolean "import_xml", default: false
    t.boolean "change_products", default: false
    t.boolean "order_client", default: false
    t.boolean "order_devolution", default: false
    t.boolean "order_cost", default: false
    t.boolean "order_done", default: false
    t.boolean "order_price_reduce", default: false
    t.boolean "order_inactive", default: false
    t.string "celphone"
    t.string "phone"
    t.string "street"
    t.string "neighborhood"
    t.string "zipcode"
    t.string "complement"
    t.string "number"
    t.string "city"
    t.bigint "city_id"
    t.boolean "change_coupon", default: false
    t.boolean "change_campain", default: false
    t.boolean "change_highlight", default: false
    t.boolean "change_bank", default: false
    t.boolean "change_carrier", default: false
    t.boolean "change_employee", default: false
    t.bigint "company_id"
    t.boolean "change_scheduled_messages", default: false
    t.index ["city_id"], name: "index_employees_on_city_id"
    t.index ["company_id"], name: "index_employees_on_company_id"
    t.index ["email"], name: "index_employees_on_email", unique: true
    t.index ["reset_password_token"], name: "index_employees_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_employees_on_uid_and_provider", unique: true
  end

  create_table "employees_permissions", id: false, force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "permission_id"
    t.index ["employee_id"], name: "index_employees_permissions_on_employee_id"
    t.index ["permission_id"], name: "index_employees_permissions_on_permission_id"
  end

  create_table "highlights", force: :cascade do |t|
    t.string "title"
    t.string "subtitle"
    t.text "metadata"
    t.string "image"
    t.datetime "expires_at"
    t.datetime "starts_in"
    t.integer "status", default: 1
    t.integer "kind", default: 0
    t.integer "position", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "link"
    t.string "secondaryImage"
  end

  create_table "ibpts", force: :cascade do |t|
    t.integer "code"
    t.text "description"
    t.float "national_aliquota"
    t.float "international_aliquota"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "image_products", force: :cascade do |t|
    t.string "attachment"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_image_products_on_product_id"
  end

  create_table "log_coupons", force: :cascade do |t|
    t.bigint "coupon_id"
    t.string "external_order_id"
    t.string "client_federal_registration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coupon_id"], name: "index_log_coupons_on_coupon_id"
  end

  create_table "log_premio_ideals", force: :cascade do |t|
    t.integer "status"
    t.text "error"
    t.text "body"
    t.bigint "partner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["partner_id"], name: "index_log_premio_ideals_on_partner_id"
  end

  create_table "log_workers", force: :cascade do |t|
    t.string "name"
    t.json "content"
    t.string "status"
    t.datetime "started_at", default: -> { "CURRENT_DATE" }
    t.datetime "finished_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.string "title"
    t.integer "target_id"
    t.string "target_type"
    t.integer "notified_id"
    t.string "notified_type"
    t.boolean "viewed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notified_id", "notified_type"], name: "index_notifications_on_notified_id_and_notified_type"
    t.index ["target_id", "target_type"], name: "index_notifications_on_target_id_and_target_type"
  end

  create_table "order_payments", force: :cascade do |t|
    t.float "value"
    t.bigint "order_id"
    t.bigint "payment_method_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_payments_on_order_id"
    t.index ["payment_method_id"], name: "index_order_payments_on_payment_method_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "type"
    t.datetime "exclusion_at"
    t.text "description"
    t.float "discount"
    t.float "freight"
    t.datetime "billing_at"
    t.bigint "cashier_id"
    t.bigint "carrier_id"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "employee_id"
    t.integer "selected_margin", limit: 2
    t.integer "discount_type", limit: 2
    t.integer "status", limit: 2
    t.string "buyer_type"
    t.integer "buyer_id"
    t.bigint "partner_id"
    t.bigint "order_id"
    t.integer "billing_employee_id"
    t.index ["buyer_type", "buyer_id"], name: "index_orders_on_buyer_type_and_buyer_id"
    t.index ["carrier_id"], name: "index_orders_on_carrier_id"
    t.index ["cashier_id"], name: "index_orders_on_cashier_id"
    t.index ["company_id"], name: "index_orders_on_company_id"
    t.index ["employee_id"], name: "index_orders_on_employee_id"
    t.index ["order_id"], name: "index_orders_on_order_id"
    t.index ["partner_id"], name: "index_orders_on_partner_id"
  end

  create_table "partner_groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "partner_projects", force: :cascade do |t|
    t.string "name", null: false
    t.integer "environment", null: false
    t.integer "status", default: 0, null: false
    t.text "status_rmk"
    t.text "content", null: false
    t.string "products"
    t.date "project_date", default: -> { "now()" }
    t.string "city"
    t.string "metadata"
    t.bigint "partner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["metadata"], name: "index_partner_projects_on_metadata"
    t.index ["partner_id"], name: "index_partner_projects_on_partner_id"
  end

  create_table "partners", force: :cascade do |t|
    t.string "name"
    t.string "federal_registration"
    t.string "state_registration"
    t.integer "kind"
    t.datetime "renewal_date"
    t.text "description"
    t.integer "origin"
    t.float "percent"
    t.string "agency"
    t.string "account"
    t.string "favored"
    t.bigint "bank_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "birthday"
    t.string "ocupation"
    t.integer "cash_redemption"
    t.bigint "partner_group_id"
    t.integer "status"
    t.string "favored_federal_registration"
    t.string "site"
    t.string "register"
    t.datetime "deleted_at"
    t.integer "deleted_by_id"
    t.integer "created_by_id"
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "project_image"
    t.string "email"
    t.json "tokens"
    t.string "instagram"
    t.string "avatar"
    t.text "aboutme"
    t.string "searcher"
    t.index ["bank_id"], name: "index_partners_on_bank_id"
    t.index ["confirmation_token"], name: "index_partners_on_confirmation_token", unique: true
    t.index ["email"], name: "index_partners_on_email", unique: true
    t.index ["partner_group_id"], name: "index_partners_on_partner_group_id"
    t.index ["reset_password_token"], name: "index_partners_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_partners_on_uid_and_provider", unique: true
  end

  create_table "payment_methods", force: :cascade do |t|
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
    t.boolean "primary", default: false
    t.index ["phone_type_id"], name: "index_phones_on_phone_type_id"
  end

  create_table "pi_vouchers", force: :cascade do |t|
    t.datetime "expiration_date"
    t.float "value"
    t.string "attachment"
    t.datetime "used_at"
    t.datetime "send_email_at"
    t.integer "status", default: 1
    t.datetime "received_at"
    t.bigint "company_id"
    t.bigint "partner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_pi_vouchers_on_company_id"
    t.index ["partner_id"], name: "index_pi_vouchers_on_partner_id"
  end

  create_table "prices", force: :cascade do |t|
    t.float "price"
    t.float "margin"
    t.integer "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "stock_id"
    t.index ["stock_id"], name: "index_prices_on_stock_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "barcode"
    t.float "weight"
    t.float "height"
    t.float "width"
    t.float "length"
    t.string "color"
    t.integer "kind"
    t.bigint "sub_category_id"
    t.bigint "unit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sku"
    t.string "sku_xml"
    t.float "ipi"
    t.float "reduction"
    t.float "suggested_price"
    t.bigint "supplier_id"
    t.float "suggested_price_site"
    t.integer "suggested_price_role", default: 0
    t.integer "status", default: 1
    t.integer "deleted_by_id"
    t.datetime "deleted_at"
    t.index ["sub_category_id"], name: "index_products_on_sub_category_id"
    t.index ["supplier_id"], name: "index_products_on_supplier_id"
    t.index ["unit_id"], name: "index_products_on_unit_id"
  end

  create_table "project_images", force: :cascade do |t|
    t.string "attachment"
    t.bigint "partner_project_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "highlight", default: true
    t.index ["partner_project_id"], name: "index_project_images_on_partner_project_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reports", force: :cascade do |t|
    t.string "name"
    t.string "attachment"
    t.bigint "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_reports_on_employee_id"
  end

  create_table "scheduled_messages", force: :cascade do |t|
    t.string "name", null: false
    t.string "text", null: false
    t.integer "status", default: 0
    t.string "receiver_type", null: false
    t.text "receiver_ids", default: [], array: true
    t.date "starts_at", default: -> { "now()" }, null: false
    t.date "finished_at"
    t.date "last_execution"
    t.date "next_execution"
    t.integer "frequency", default: 1, null: false
    t.integer "frequency_type", default: 0, null: false
    t.string "repeat"
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_scheduled_messages_on_created_by_id"
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.string "acronym"
    t.bigint "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_states_on_region_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.float "stock"
    t.float "stock_max"
    t.float "stock_min"
    t.bigint "company_id"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "cost"
    t.float "discount"
    t.float "st"
    t.float "margin"
    t.float "pmva"
    t.float "vbc"
    t.float "vbcst"
    t.float "vicms"
    t.float "picms"
    t.float "vicmsst"
    t.float "picmsst"
    t.index ["company_id"], name: "index_stocks_on_company_id"
    t.index ["product_id"], name: "index_stocks_on_product_id"
  end

  create_table "sub_categories", force: :cascade do |t|
    t.string "name"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_sub_categories_on_category_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name"
    t.string "fantasy_name"
    t.string "federal_registration"
    t.string "state_registration"
    t.integer "kind"
    t.datetime "birth_date"
    t.integer "tax_regime"
    t.text "description"
    t.bigint "billing_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["billing_type_id"], name: "index_suppliers_on_billing_type_id"
  end

  create_table "units", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "brand"
    t.string "model"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "zipcodes", force: :cascade do |t|
    t.string "code"
    t.string "place"
    t.string "neighborhood"
    t.bigint "city_id"
    t.string "ibge"
    t.string "gia"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_zipcodes_on_city_id"
  end

  add_foreign_key "addresses", "address_types"
  add_foreign_key "addresses", "cities"
  add_foreign_key "cashier_payments", "cashiers"
  add_foreign_key "cashier_payments", "payment_methods"
  add_foreign_key "cities", "states"
  add_foreign_key "clients", "billing_types"
  add_foreign_key "commissions", "partners"
  add_foreign_key "coupons", "partners"
  add_foreign_key "emails", "email_types"
  add_foreign_key "employees", "cities"
  add_foreign_key "employees", "companies"
  add_foreign_key "image_products", "products"
  add_foreign_key "log_coupons", "coupons"
  add_foreign_key "log_premio_ideals", "partners"
  add_foreign_key "order_payments", "orders"
  add_foreign_key "order_payments", "payment_methods"
  add_foreign_key "orders", "carriers"
  add_foreign_key "orders", "cashiers"
  add_foreign_key "orders", "companies"
  add_foreign_key "orders", "orders"
  add_foreign_key "orders", "partners"
  add_foreign_key "partner_projects", "partners"
  add_foreign_key "partners", "banks"
  add_foreign_key "phones", "phone_types"
  add_foreign_key "pi_vouchers", "companies"
  add_foreign_key "pi_vouchers", "partners"
  add_foreign_key "prices", "stocks"
  add_foreign_key "products", "sub_categories"
  add_foreign_key "products", "units"
  add_foreign_key "project_images", "partner_projects"
  add_foreign_key "reports", "employees"
  add_foreign_key "scheduled_messages", "employees", column: "created_by_id"
  add_foreign_key "states", "regions"
  add_foreign_key "stocks", "companies"
  add_foreign_key "stocks", "products"
  add_foreign_key "sub_categories", "categories"
  add_foreign_key "suppliers", "billing_types"
  add_foreign_key "zipcodes", "cities"
end
