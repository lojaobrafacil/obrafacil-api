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

ActiveRecord::Schema.define(version: 20171106173742) do

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
  add_foreign_key "cities", "states"
  add_foreign_key "clients", "billing_types"
  add_foreign_key "clients", "users"
  add_foreign_key "companies", "billing_types"
  add_foreign_key "companies", "users"
  add_foreign_key "emails", "email_types"
  add_foreign_key "partners", "banks"
  add_foreign_key "partners", "billing_types"
  add_foreign_key "partners", "users"
  add_foreign_key "phones", "phone_types"
  add_foreign_key "states", "regions"
end
