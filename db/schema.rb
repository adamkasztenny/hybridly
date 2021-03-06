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

ActiveRecord::Schema.define(version: 2021_07_13_022826) do

  create_table "reservation_policies", force: :cascade do |t|
    t.integer "capacity", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_at"], name: "index_reservation_policies_on_created_at"
    t.index ["user_id"], name: "index_reservation_policies_on_user_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.date "date", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "workspace_id"
    t.string "verification_code", null: false
    t.integer "verified_by_id"
    t.index ["user_id", "date"], name: "index_reservations_on_user_id_and_date", unique: true
    t.index ["user_id"], name: "index_reservations_on_user_id"
    t.index ["verified_by_id"], name: "index_reservations_on_verified_by_id"
    t.index ["workspace_id"], name: "index_reservations_on_workspace_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.integer "resource_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "workspaces", force: :cascade do |t|
    t.string "location"
    t.integer "capacity"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "workspace_type"
    t.index ["location", "workspace_type"], name: "index_workspaces_on_location_and_workspace_type", unique: true
    t.index ["user_id"], name: "index_workspaces_on_user_id"
  end

  add_foreign_key "reservation_policies", "users"
  add_foreign_key "reservations", "users"
  add_foreign_key "reservations", "users", column: "verified_by_id"
  add_foreign_key "reservations", "workspaces"
  add_foreign_key "workspaces", "users"
end
