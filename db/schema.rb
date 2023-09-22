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

ActiveRecord::Schema[7.0].define(version: 2023_09_22_075530) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.text "provider", default: "email", null: false
    t.text "uid", default: "", null: false
    t.text "encrypted_password", default: "", null: false
    t.text "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.text "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.text "unconfirmed_email"
    t.text "name"
    t.text "nickname"
    t.text "image"
    t.text "email"
    t.text "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_admins_on_confirmation_token", unique: true
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_admins_on_uid_and_provider", unique: true
  end

  create_table "booking_dog_profiles", force: :cascade do |t|
    t.bigint "booking_id", null: false
    t.bigint "dog_profile_id", null: false
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_booking_dog_profiles_on_booking_id"
    t.index ["dog_profile_id"], name: "index_booking_dog_profiles_on_dog_profile_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "dog_walking_job_id", null: false
    t.date "date"
    t.decimal "amount"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "duration"
    t.boolean "archived", default: false
    t.index ["dog_walking_job_id"], name: "index_bookings_on_dog_walking_job_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "chatrooms", force: :cascade do |t|
    t.bigint "booking_id", null: false
    t.bigint "walker_user_id"
    t.bigint "owner_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_chatrooms_on_booking_id"
    t.index ["owner_user_id"], name: "index_chatrooms_on_owner_user_id"
    t.index ["walker_user_id"], name: "index_chatrooms_on_walker_user_id"
  end

  create_table "dog_profiles", force: :cascade do |t|
    t.text "name"
    t.text "breed"
    t.integer "age"
    t.text "sex"
    t.integer "weight"
    t.boolean "hidden"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "archived", default: false
    t.index ["user_id"], name: "index_dog_profiles_on_user_id"
  end

  create_table "dog_walking_jobs", force: :cascade do |t|
    t.text "name"
    t.integer "wgr1"
    t.integer "wgr2"
    t.integer "wgr3"
    t.integer "wgs1"
    t.integer "wgs2"
    t.integer "wgs3"
    t.boolean "hidden"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "archived", default: false
    t.index ["user_id"], name: "index_dog_walking_jobs_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id", null: false
    t.bigint "chatroom_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chatroom_id"], name: "index_messages_on_chatroom_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.bigint "dog_walking_job_id", null: false
    t.integer "day"
    t.time "start_time"
    t.time "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dog_walking_job_id"], name: "index_schedules_on_dog_walking_job_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "provider", default: "email", null: false
    t.text "uid", default: "", null: false
    t.text "encrypted_password", default: "", null: false
    t.text "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.text "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.text "unconfirmed_email"
    t.text "name"
    t.text "email"
    t.text "kind"
    t.text "status", default: "pending"
    t.text "street_address"
    t.text "city"
    t.text "state"
    t.text "country"
    t.text "cached_geocode"
    t.text "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "booking_dog_profiles", "bookings"
  add_foreign_key "booking_dog_profiles", "dog_profiles"
  add_foreign_key "bookings", "dog_walking_jobs"
  add_foreign_key "bookings", "users"
  add_foreign_key "chatrooms", "bookings"
  add_foreign_key "chatrooms", "users", column: "owner_user_id"
  add_foreign_key "chatrooms", "users", column: "walker_user_id"
  add_foreign_key "dog_profiles", "users"
  add_foreign_key "dog_walking_jobs", "users"
  add_foreign_key "messages", "chatrooms"
  add_foreign_key "messages", "users"
  add_foreign_key "schedules", "dog_walking_jobs"
end
