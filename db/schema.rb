# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_29_084916) do
  create_table "app_accesses", force: :cascade do |t|
    t.integer "app_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_id"], name: "index_app_accesses_on_app_id"
    t.index ["user_id", "app_id"], name: "index_app_accesses_on_user_id_and_app_id", unique: true
    t.index ["user_id"], name: "index_app_accesses_on_user_id"
  end

  create_table "app_activities", force: :cascade do |t|
    t.integer "activity_type", null: false
    t.string "app_meta"
    t.integer "app_id", null: false
    t.integer "user_id", null: false
    t.datetime "timestamp", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_id", "timestamp"], name: "index_app_activities_on_app_id_and_timestamp"
    t.index ["app_id"], name: "index_app_activities_on_app_id"
    t.index ["timestamp"], name: "index_app_activities_on_timestamp"
    t.index ["user_id", "timestamp"], name: "index_app_activities_on_user_id_and_timestamp"
    t.index ["user_id"], name: "index_app_activities_on_user_id"
  end

  create_table "apps", force: :cascade do |t|
    t.string "app_name", null: false
    t.text "description"
    t.string "category"
    t.string "sector"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_name"], name: "index_apps_on_app_name", unique: true
    t.index ["category"], name: "index_apps_on_category"
    t.index ["sector"], name: "index_apps_on_sector"
  end

  create_table "credit_spents", force: :cascade do |t|
    t.datetime "timestamp", null: false
    t.integer "user_id", null: false
    t.decimal "credit_spent", precision: 10, scale: 2, null: false
    t.integer "spend_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["timestamp"], name: "index_credit_spents_on_timestamp"
    t.index ["user_id", "timestamp"], name: "index_credit_spents_on_user_id_and_timestamp"
    t.index ["user_id"], name: "index_credit_spents_on_user_id"
  end

  create_table "credit_topups", force: :cascade do |t|
    t.datetime "timestamp", null: false
    t.integer "user_id", null: false
    t.decimal "credit_topup", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["timestamp"], name: "index_credit_topups_on_timestamp"
    t.index ["user_id", "timestamp"], name: "index_credit_topups_on_user_id_and_timestamp"
    t.index ["user_id"], name: "index_credit_topups_on_user_id"
  end

  create_table "forget_passwords", force: :cascade do |t|
    t.string "email", null: false
    t.decimal "code", precision: 6, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email", "code"], name: "index_forget_passwords_on_email_and_code"
    t.index ["email"], name: "index_forget_passwords_on_email"
  end

  create_table "log_in_histories", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "timestamp", null: false
    t.text "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["timestamp"], name: "index_log_in_histories_on_timestamp"
    t.index ["user_id", "timestamp"], name: "index_log_in_histories_on_user_id_and_timestamp"
    t.index ["user_id"], name: "index_log_in_histories_on_user_id"
  end

  create_table "stripe_infos", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "stripe_customer_id", null: false
    t.string "subscription_id"
    t.string "subscription_status"
    t.datetime "next_subscription_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stripe_customer_id"], name: "index_stripe_infos_on_stripe_customer_id", unique: true
    t.index ["subscription_id"], name: "index_stripe_infos_on_subscription_id"
    t.index ["subscription_status"], name: "index_stripe_infos_on_subscription_status"
    t.index ["user_id"], name: "index_stripe_infos_on_user_id"
  end

  create_table "tiers", force: :cascade do |t|
    t.string "tier_name", null: false
    t.string "stripe_price_id", null: false
    t.decimal "monthly_credit", precision: 10, scale: 2, null: false
    t.decimal "monthly_tier_price", precision: 10, scale: 2, null: false
    t.decimal "yearly_tier_price", precision: 10, scale: 2, null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stripe_price_id"], name: "index_tiers_on_stripe_price_id", unique: true
    t.index ["tier_name"], name: "index_tiers_on_tier_name", unique: true
  end

  create_table "user_roles", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "role"], name: "index_user_roles_on_user_id_and_role", unique: true
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "google_id"
    t.string "first_name"
    t.string "last_name"
    t.string "country"
    t.boolean "age_consent", default: false
    t.string "password"
    t.string "avatar"
    t.string "nick_name"
    t.string "linkedIn"
    t.string "twitter"
    t.decimal "monthly_credit_balance", precision: 10, scale: 2, default: "0.0"
    t.decimal "top_up_credit_balance", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tier_id"
    t.string "encrypted_password", default: "", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["google_id"], name: "index_users_on_google_id", unique: true
    t.index ["nick_name"], name: "index_users_on_nick_name", unique: true
    t.index ["tier_id"], name: "index_users_on_tier_id"
  end

  add_foreign_key "app_accesses", "apps"
  add_foreign_key "app_accesses", "users"
  add_foreign_key "app_activities", "apps"
  add_foreign_key "app_activities", "users"
  add_foreign_key "credit_spents", "users"
  add_foreign_key "credit_topups", "users"
  add_foreign_key "log_in_histories", "users"
  add_foreign_key "stripe_infos", "users"
  add_foreign_key "user_roles", "users"
  add_foreign_key "users", "tiers"
end
