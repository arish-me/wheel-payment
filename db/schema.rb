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

ActiveRecord::Schema[8.0].define(version: 2025_08_21_083506) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "disputes", force: :cascade do |t|
    t.bigint "milestone_id", null: false
    t.bigint "raised_by_id", null: false
    t.text "reason"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["milestone_id"], name: "index_disputes_on_milestone_id"
    t.index ["raised_by_id"], name: "index_disputes_on_raised_by_id"
  end

  create_table "milestones", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "amount_cents"
    t.string "currency"
    t.integer "status"
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_milestones_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "client_id", null: false
    t.bigint "developer_id", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_projects_on_client_id"
    t.index ["developer_id"], name: "index_projects_on_developer_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "milestone_id", null: false
    t.bigint "reviewer_id", null: false
    t.bigint "reviewed_id", null: false
    t.integer "rating"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["milestone_id"], name: "index_reviews_on_milestone_id"
    t.index ["reviewed_id"], name: "index_reviews_on_reviewed_id"
    t.index ["reviewer_id"], name: "index_reviews_on_reviewer_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "milestone_id", null: false
    t.string "payment_provider"
    t.string "provider_id"
    t.integer "status"
    t.integer "fee_cents"
    t.integer "net_amount_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["milestone_id"], name: "index_transactions_on_milestone_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "disputes", "milestones"
  add_foreign_key "disputes", "users", column: "raised_by_id"
  add_foreign_key "milestones", "projects"
  add_foreign_key "projects", "users", column: "client_id"
  add_foreign_key "projects", "users", column: "developer_id"
  add_foreign_key "reviews", "milestones"
  add_foreign_key "reviews", "users", column: "reviewed_id"
  add_foreign_key "reviews", "users", column: "reviewer_id"
  add_foreign_key "transactions", "milestones"
end
