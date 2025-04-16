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

ActiveRecord::Schema[8.0].define(version: 2025_04_16_165305) do
  create_table "hashtaggings", force: :cascade do |t|
    t.integer "rubit_id", null: false
    t.integer "hashtag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hashtag_id"], name: "index_hashtaggings_on_hashtag_id"
    t.index ["rubit_id", "hashtag_id"], name: "index_hashtaggings_on_rubit_id_and_hashtag_id", unique: true
    t.index ["rubit_id"], name: "index_hashtaggings_on_rubit_id"
  end

  create_table "hashtags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_hashtags_on_name", unique: true
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "rubit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rubit_id"], name: "index_likes_on_rubit_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "rubits", force: :cascade do |t|
    t.text "content"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_rubit_id"
    t.index ["parent_rubit_id"], name: "index_rubits_on_parent_rubit_id"
    t.index ["user_id"], name: "index_rubits_on_user_id"
  end

  create_table "seen_rubits", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "rubit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rubit_id"], name: "index_seen_rubits_on_rubit_id"
    t.index ["user_id"], name: "index_seen_rubits_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "hashtaggings", "hashtags"
  add_foreign_key "hashtaggings", "rubits"
  add_foreign_key "likes", "rubits"
  add_foreign_key "likes", "users"
  add_foreign_key "rubits", "rubits", column: "parent_rubit_id"
  add_foreign_key "rubits", "users"
  add_foreign_key "seen_rubits", "rubits"
  add_foreign_key "seen_rubits", "users"
end
