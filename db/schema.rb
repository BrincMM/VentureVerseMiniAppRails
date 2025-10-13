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

ActiveRecord::Schema[8.0].define(version: 2025_10_13_070254) do
  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "api_keys", force: :cascade do |t|
    t.integer "app_id", null: false
    t.string "api_key", null: false
    t.integer "rate_limit_per_minute", default: 100
    t.integer "rate_limit_per_day", default: 10000
    t.integer "status", default: 0, null: false
    t.datetime "expires_at"
    t.datetime "last_used_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_key"], name: "index_api_keys_on_api_key", unique: true
    t.index ["app_id"], name: "index_api_keys_on_app_id"
    t.index ["status"], name: "index_api_keys_on_status"
  end

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
    t.string "name", null: false
    t.text "description"
    t.string "app_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sort_order", default: 0
    t.integer "category_id"
    t.integer "sector_id"
    t.integer "developer_id"
    t.integer "status"
    t.index ["category_id"], name: "index_apps_on_category_id"
    t.index ["developer_id"], name: "index_apps_on_developer_id"
    t.index ["name"], name: "index_apps_on_name"
    t.index ["sector_id"], name: "index_apps_on_sector_id"
    t.index ["sort_order"], name: "index_apps_on_sort_order"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "credit_spents", force: :cascade do |t|
    t.datetime "timestamp", null: false
    t.integer "user_id", null: false
    t.decimal "credits", precision: 10, scale: 2, null: false
    t.integer "spend_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "cost_in_usd", precision: 10, scale: 2, null: false
    t.index ["timestamp"], name: "index_credit_spents_on_timestamp"
    t.index ["user_id", "timestamp"], name: "index_credit_spents_on_user_id_and_timestamp"
    t.index ["user_id"], name: "index_credit_spents_on_user_id"
  end

  create_table "credit_topups", force: :cascade do |t|
    t.datetime "timestamp", null: false
    t.integer "user_id", null: false
    t.decimal "credits", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["timestamp"], name: "index_credit_topups_on_timestamp"
    t.index ["user_id", "timestamp"], name: "index_credit_topups_on_user_id_and_timestamp"
    t.index ["user_id"], name: "index_credit_topups_on_user_id"
  end

  create_table "developers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.string "github"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "status", default: 0, null: false
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_developers_on_confirmation_token", unique: true
    t.index ["email"], name: "index_developers_on_email", unique: true
    t.index ["github"], name: "index_developers_on_github"
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

  create_table "perk_accesses", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "perk_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["perk_id"], name: "index_perk_accesses_on_perk_id"
    t.index ["user_id", "perk_id"], name: "index_perk_accesses_on_user_id_and_perk_id", unique: true
    t.index ["user_id"], name: "index_perk_accesses_on_user_id"
  end

  create_table "perks", force: :cascade do |t|
    t.string "partner_name", null: false
    t.string "company_website", null: false
    t.string "contact_email", null: false
    t.string "contact", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category_id"
    t.integer "sector_id"
    t.index ["category_id"], name: "index_perks_on_category_id"
    t.index ["sector_id"], name: "index_perks_on_sector_id"
  end

  create_table "sectors", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_sectors_on_name", unique: true
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

  create_table "taggings", force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
    t.index ["tenant"], name: "index_taggings_on_tenant"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "tiers", force: :cascade do |t|
    t.string "name", null: false
    t.string "stripe_price_id", null: false
    t.decimal "monthly_credit", precision: 10, scale: 2, null: false
    t.decimal "monthly_tier_price", precision: 10, scale: 2, null: false
    t.decimal "yearly_tier_price", precision: 10, scale: 2, null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tiers_on_name", unique: true
    t.index ["stripe_price_id"], name: "index_tiers_on_stripe_price_id", unique: true
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
    t.string "first_name", null: false
    t.string "last_name"
    t.string "country"
    t.boolean "age_consent", default: false
    t.string "avatar"
    t.string "nick_name"
    t.string "linkedIn"
    t.string "twitter"
    t.decimal "monthly_credit_balance", precision: 10, scale: 2, default: "0.0"
    t.decimal "topup_credit_balance", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tier_id"
    t.string "encrypted_password", default: "", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["google_id"], name: "index_users_on_google_id", unique: true
    t.index ["nick_name"], name: "index_users_on_nick_name", unique: true
    t.index ["tier_id"], name: "index_users_on_tier_id"
  end

  create_table "waiting_lists", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "subscribe_type", default: 0, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "name"
    t.datetime "beehiiv_synced_at"
    t.boolean "beehiiv_sync_is_success"
    t.text "beehiiv_sync_error"
    t.string "beehiiv_subscriber_id"
    t.boolean "send_welcome_email_is_success"
    t.datetime "send_welcome_email_at"
    t.index ["email"], name: "index_waiting_lists_on_email", unique: true
    t.index ["subscribe_type"], name: "index_waiting_lists_on_subscribe_type"
  end

  add_foreign_key "api_keys", "apps"
  add_foreign_key "app_accesses", "apps"
  add_foreign_key "app_accesses", "users"
  add_foreign_key "app_activities", "apps"
  add_foreign_key "app_activities", "users"
  add_foreign_key "apps", "categories"
  add_foreign_key "apps", "developers", on_delete: :nullify
  add_foreign_key "apps", "sectors"
  add_foreign_key "credit_spents", "users"
  add_foreign_key "credit_topups", "users"
  add_foreign_key "log_in_histories", "users"
  add_foreign_key "perk_accesses", "perks"
  add_foreign_key "perk_accesses", "users"
  add_foreign_key "perks", "categories"
  add_foreign_key "perks", "sectors"
  add_foreign_key "stripe_infos", "users"
  add_foreign_key "taggings", "tags"
  add_foreign_key "user_roles", "users"
  add_foreign_key "users", "tiers"
end
