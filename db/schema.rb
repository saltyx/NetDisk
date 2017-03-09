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

ActiveRecord::Schema.define(version: 20170309131043) do

  create_table "user_files", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "file_name"
    t.float    "file_size",      limit: 24
    t.string   "file_path"
    t.boolean  "is_folder"
    t.integer  "from_folder"
    t.boolean  "is_shared"
    t.boolean  "is_encrypted"
    t.string   "download_link"
    t.integer  "download_times"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "iv"
    t.string   "sha256"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.boolean  "is_admin"
    t.string   "last_login_ip"
    t.datetime "last_login_time"
    t.string   "last_login_device"
    t.float    "total_storage",     limit: 24
    t.float    "used_storage",      limit: 24
    t.string   "password_digest"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "token"
  end

end
