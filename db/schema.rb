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

ActiveRecord::Schema[7.0].define(version: 2022_08_01_023101) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "appointments", force: :cascade do |t|
    t.bigint "office_id"
    t.date "meet_date"
    t.string "meet_time"
    t.string "name"
    t.string "age"
    t.string "phone_number"
    t.string "comment"
    t.bigint "user_id"
    t.integer "called_status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["office_id"], name: "index_appointments_on_office_id"
    t.index ["user_id"], name: "index_appointments_on_user_id"
  end

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "office_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["office_id", "user_id"], name: "ci_bookmarks_01", unique: true
    t.index ["office_id"], name: "index_bookmarks_on_office_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "care_recipients", force: :cascade do |t|
    t.string "name"
    t.string "kana"
    t.integer "age"
    t.string "post_code"
    t.string "address"
    t.string "family"
    t.bigint "office_id"
    t.bigint "staff_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["office_id"], name: "index_care_recipients_on_office_id"
    t.index ["staff_id"], name: "index_care_recipients_on_staff_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "types"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "histories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "office_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["office_id"], name: "index_histories_on_office_id"
    t.index ["user_id", "office_id"], name: "ci_histories_01", unique: true
    t.index ["user_id"], name: "index_histories_on_user_id"
  end

  create_table "office_details", force: :cascade do |t|
    t.bigint "office_id", null: false
    t.string "detail", null: false
    t.string "service_type", null: false
    t.string "open_date"
    t.integer "rooms"
    t.string "requirement"
    t.string "facility"
    t.string "management"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["office_id"], name: "index_office_details_on_office_id"
  end

  create_table "offices", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.integer "flags", default: 0, null: false
    t.string "business_day_detail"
    t.string "address"
    t.string "post_code"
    t.string "phone_number"
    t.string "fax_number"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "selected_flags"
    t.index ["user_id"], name: "index_offices_on_user_id"
  end

  create_table "specialists", force: :cascade do |t|
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
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_specialists_on_confirmation_token", unique: true
    t.index ["email"], name: "index_specialists_on_email", unique: true
    t.index ["reset_password_token"], name: "index_specialists_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_specialists_on_uid_and_provider", unique: true
  end

  create_table "staffs", force: :cascade do |t|
    t.string "name"
    t.string "kana"
    t.string "introduction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "office_id"
    t.index ["office_id"], name: "index_staffs_on_office_id"
  end

  create_table "thanks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "office_id", null: false
    t.bigint "staff_id", null: false
    t.string "comments", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", limit: 30, null: false
    t.integer "age", null: false
    t.index ["office_id"], name: "index_thanks_on_office_id"
    t.index ["staff_id"], name: "index_thanks_on_staff_id"
    t.index ["user_id", "office_id", "staff_id"], name: "ci_thanks_01", unique: true
    t.index ["user_id"], name: "index_thanks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
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
    t.string "name"
    t.string "phone_number"
    t.string "post_code"
    t.string "address"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_type", default: 0, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "appointments", "offices"
  add_foreign_key "appointments", "users"
  add_foreign_key "bookmarks", "offices"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "care_recipients", "offices"
  add_foreign_key "care_recipients", "staffs"
  add_foreign_key "histories", "offices"
  add_foreign_key "histories", "users"
  add_foreign_key "office_details", "offices"
  add_foreign_key "offices", "users"
  add_foreign_key "staffs", "offices"
  add_foreign_key "thanks", "offices"
  add_foreign_key "thanks", "staffs"
  add_foreign_key "thanks", "users"
end
