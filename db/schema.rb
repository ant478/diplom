# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160327154500) do

  create_table "categories", force: :cascade do |t|
    t.string   "name",        limit: 50,                    null: false
    t.string   "description", limit: 250
    t.text     "avatar_link", limit: 65535
    t.boolean  "is_archived",               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["is_archived"], name: "IXFX_is_archived", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "rate",       limit: 1,   null: false
    t.string   "text",       limit: 250
    t.integer  "product_id", limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["product_id"], name: "IXFK_comment_product", using: :btree
  add_index "comments", ["user_id"], name: "IXFK_comment_user", using: :btree

  create_table "countries", force: :cascade do |t|
    t.string   "name",       limit: 50, null: false
    t.string   "phone_code", limit: 50, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "countries", ["name"], name: "IXFX_name", using: :btree
  add_index "countries", ["phone_code"], name: "IXFX_phone_code", using: :btree

  create_table "currencies", force: :cascade do |t|
    t.string   "name",       limit: 50,                          null: false
    t.string   "code",       limit: 5,                           null: false
    t.decimal  "rate",                  precision: 10, scale: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deals", force: :cascade do |t|
    t.integer  "seller_id",   limit: 4
    t.integer  "buyer_id",    limit: 4
    t.integer  "product_id",  limit: 4
    t.decimal  "price",                 precision: 12, scale: 2, null: false
    t.integer  "currency_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deals", ["buyer_id"], name: "IXFK_deal_user_02", using: :btree
  add_index "deals", ["currency_id"], name: "FK_deal_currency", using: :btree
  add_index "deals", ["product_id"], name: "IXFK_deal_product", using: :btree
  add_index "deals", ["seller_id"], name: "IXFK_deal_user", using: :btree

  create_table "payment_infos", force: :cascade do |t|
    t.string   "name",        limit: 50,    null: false
    t.text     "data",        limit: 65535, null: false
    t.integer  "currency_id", limit: 4
    t.integer  "user_id",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payment_infos", ["currency_id"], name: "IXFK_payment_info_currency", using: :btree
  add_index "payment_infos", ["user_id"], name: "IXFK_payment_info_user", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name",        limit: 250,                                          null: false
    t.string   "description", limit: 500,                                          null: false
    t.decimal  "price",                   precision: 12, scale: 2,                 null: false
    t.integer  "quantity",    limit: 4,                                            null: false
    t.integer  "rating",      limit: 4,                            default: 0,     null: false
    t.integer  "rates_count", limit: 4,                            default: 0,     null: false
    t.boolean  "is_paused",                                        default: false
    t.boolean  "is_archived",                                      default: false
    t.boolean  "is_blocked",                                       default: false
    t.integer  "currency_id", limit: 4
    t.integer  "category_id", limit: 4
    t.integer  "owner_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["category_id"], name: "IXFK_product_category", using: :btree
  add_index "products", ["currency_id"], name: "FK_product_currency", using: :btree
  add_index "products", ["is_archived"], name: "IXFX_is_archived", using: :btree
  add_index "products", ["owner_id"], name: "IXFK_product_user", using: :btree

  create_table "properties", force: :cascade do |t|
    t.string   "name",             limit: 50,  null: false
    t.string   "description",      limit: 250
    t.integer  "category_id",      limit: 4,   null: false
    t.integer  "property_type_id", limit: 4,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "properties", ["category_id"], name: "IXFK_property_type_category", using: :btree
  add_index "properties", ["property_type_id"], name: "IXFK_property_property_type", using: :btree

  create_table "property_parameters", force: :cascade do |t|
    t.integer  "key",         limit: 4
    t.text     "value",       limit: 65535, null: false
    t.integer  "property_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "property_parameters", ["property_id"], name: "IXFK_property_parameters_property_type", using: :btree

  create_table "property_types", force: :cascade do |t|
    t.string   "name",         limit: 50,  null: false
    t.string   "description",  limit: 250
    t.string   "display_name", limit: 50,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "property_values", force: :cascade do |t|
    t.text     "value",       limit: 65535, null: false
    t.integer  "property_id", limit: 4
    t.integer  "product_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "property_values", ["product_id"], name: "IXFK_property_value_product", using: :btree
  add_index "property_values", ["property_id"], name: "IXFK_property_value_property_type", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",                        limit: 50
    t.boolean  "can_see_products",                       default: false
    t.boolean  "can_create_products",                    default: false
    t.boolean  "can_create_categories",                  default: false
    t.boolean  "can_buy_products",                       default: false
    t.boolean  "can_comment",                            default: false
    t.boolean  "can_moderate",                           default: false
    t.boolean  "can_chat",                               default: false
    t.boolean  "can_see_statistics",                     default: false
    t.boolean  "can_create_moderators",                  default: false
    t.boolean  "can_create_priveleged_users",            default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "sender_id",                limit: 4
    t.integer  "sender_payment_info_id",   limit: 4
    t.integer  "receiver_id",              limit: 4
    t.integer  "reseiver_payment_info_id", limit: 4
    t.decimal  "price",                              precision: 10, scale: 4, null: false
    t.integer  "deal_id",                  limit: 4
    t.integer  "currency_id",              limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transactions", ["currency_id"], name: "IXFK_transactions_currencies", using: :btree
  add_index "transactions", ["deal_id"], name: "FK_transaction_deal", using: :btree
  add_index "transactions", ["receiver_id"], name: "FK_transaction_user_02", using: :btree
  add_index "transactions", ["reseiver_payment_info_id"], name: "IXFK_transactions_payment_infos_02", using: :btree
  add_index "transactions", ["sender_id"], name: "FK_transaction_user", using: :btree
  add_index "transactions", ["sender_payment_info_id"], name: "IXFK_transactions_payment_infos", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",              limit: 254,                   null: false
    t.string   "login",              limit: 50,                    null: false
    t.string   "encrypted_password", limit: 64,                    null: false
    t.string   "first_name",         limit: 50,                    null: false
    t.string   "last_name",          limit: 50,                    null: false
    t.string   "passport_id",        limit: 50,                    null: false
    t.text     "avatar_url",         limit: 65535
    t.string   "address_line_1",     limit: 250,                   null: false
    t.string   "address_line_2",     limit: 250
    t.string   "post_index",         limit: 50
    t.string   "phone_number",       limit: 50,                    null: false
    t.date     "birth_date",                                       null: false
    t.boolean  "is_blocked",                       default: false, null: false
    t.boolean  "is_archived",                      default: false, null: false
    t.integer  "role_id",            limit: 4
    t.integer  "country_id",         limit: 4
    t.string   "token",              limit: 50
    t.datetime "token_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["country_id"], name: "IXFK_user_country", using: :btree
  add_index "users", ["email"], name: "IXFK_email", using: :btree
  add_index "users", ["login"], name: "IXFK_login", using: :btree
  add_index "users", ["role_id"], name: "IXFK_user_role", using: :btree
  add_index "users", ["token"], name: "IX_token", using: :btree

  add_foreign_key "comments", "products", name: "FK_comment_product", on_update: :cascade, on_delete: :cascade
  add_foreign_key "comments", "users", name: "FK_comment_user", on_update: :cascade, on_delete: :nullify
  add_foreign_key "deals", "currencies", name: "FK_deal_currency", on_update: :cascade
  add_foreign_key "deals", "products", name: "FK_deal_product", on_update: :cascade, on_delete: :nullify
  add_foreign_key "deals", "users", column: "seller_id", name: "FK_deal_user", on_update: :cascade, on_delete: :nullify
  add_foreign_key "payment_infos", "currencies", name: "FK_payment_info_currency", on_update: :cascade, on_delete: :cascade
  add_foreign_key "payment_infos", "users", name: "FK_payment_info_user", on_update: :cascade, on_delete: :nullify
  add_foreign_key "products", "categories", name: "FK_product_category", on_update: :cascade, on_delete: :cascade
  add_foreign_key "products", "currencies", name: "FK_product_currency"
  add_foreign_key "products", "users", column: "owner_id", name: "FK_product_user", on_update: :cascade, on_delete: :cascade
  add_foreign_key "properties", "categories", name: "FK_property_type_category", on_update: :cascade, on_delete: :cascade
  add_foreign_key "properties", "property_types", name: "FK_property_property_type", on_update: :cascade, on_delete: :cascade
  add_foreign_key "property_parameters", "properties", name: "FK_property_parameters_property_type", on_update: :cascade, on_delete: :cascade
  add_foreign_key "property_values", "products", name: "FK_property_value_product", on_update: :cascade, on_delete: :cascade
  add_foreign_key "property_values", "properties", name: "FK_property_value_property_type", on_update: :cascade, on_delete: :cascade
  add_foreign_key "transactions", "currencies", name: "FK_transactions_currencies"
  add_foreign_key "transactions", "deals", name: "FK_transaction_deal", on_delete: :nullify
  add_foreign_key "transactions", "payment_infos", column: "reseiver_payment_info_id", name: "FK_transactions_payment_infos_02", on_update: :cascade
  add_foreign_key "transactions", "payment_infos", column: "sender_payment_info_id", name: "FK_transactions_payment_infos", on_update: :cascade
  add_foreign_key "transactions", "users", column: "receiver_id", name: "FK_transaction_user_02", on_delete: :nullify
  add_foreign_key "transactions", "users", column: "sender_id", name: "FK_transaction_user", on_update: :cascade, on_delete: :nullify
  add_foreign_key "users", "countries", name: "FK_user_country", on_update: :cascade
  add_foreign_key "users", "roles", name: "FK_user_role", on_update: :cascade
end
