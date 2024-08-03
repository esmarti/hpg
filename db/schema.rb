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

ActiveRecord::Schema[7.1].define(version: 2024_08_03_070530) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "credentials", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "pass"
    t.text "description"
    t.bigint "owner_id"
    t.bigint "encrypted_for_id"
    t.bigint "team_id"
    t.index ["encrypted_for_id"], name: "index_credentials_on_encrypted_for_id"
    t.index ["owner_id"], name: "index_credentials_on_owner_id"
    t.index ["team_id"], name: "index_credentials_on_team_id"
  end

  create_table "gpg_keys", force: :cascade do |t|
    t.text "description"
    t.text "gpg_public_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "team_memberships", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_team_memberships_on_team_id"
    t.index ["user_id"], name: "index_team_memberships_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "owner_id"
    t.index ["owner_id"], name: "index_teams_on_owner_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "lastname"
    t.string "email"
    t.integer "role", default: 0
    t.bigint "gpg_key_id"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.index ["email"], name: "index_users_on_email"
    t.index ["gpg_key_id"], name: "index_users_on_gpg_key_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "credentials", "teams"
  add_foreign_key "credentials", "users", column: "encrypted_for_id"
  add_foreign_key "credentials", "users", column: "owner_id"
  add_foreign_key "team_memberships", "teams"
  add_foreign_key "team_memberships", "users"
  add_foreign_key "teams", "users", column: "owner_id"
  add_foreign_key "users", "gpg_keys"
end
