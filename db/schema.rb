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

ActiveRecord::Schema.define(version: 20181223045313) do

  create_table "idol_threads", force: :cascade do |t|
    t.integer "idol_id"
    t.string "name", null: false
    t.integer "thread_num", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["idol_id", "thread_num"], name: "index_idol_threads_on_idol_id_and_thread_num", unique: true
    t.index ["idol_id"], name: "index_idol_threads_on_idol_id"
  end

  create_table "idols", force: :cascade do |t|
    t.string "name", null: false
    t.integer "idol_num", null: false
    t.text "icon_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_idols_on_name", unique: true
  end

  create_table "thread_responses", force: :cascade do |t|
    t.integer "idol_thread_id"
    t.integer "user_id"
    t.string "ip_addr"
    t.integer "res_no", null: false
    t.text "content", null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["idol_thread_id", "res_no"], name: "index_thread_responses_on_idol_thread_id_and_res_no", unique: true
    t.index ["idol_thread_id"], name: "index_thread_responses_on_idol_thread_id"
    t.index ["user_id"], name: "index_thread_responses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "line_uid", null: false
    t.text "access_token"
    t.text "refresh_token"
    t.datetime "access_token_expires_at"
    t.string "display_name", null: false
    t.boolean "banned", default: false, null: false
    t.datetime "last_wrote_at"
    t.datetime "last_thread_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
