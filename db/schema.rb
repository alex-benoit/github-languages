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

ActiveRecord::Schema.define(version: 20161008164155) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "users", force: :cascade do |t|
    t.string   "login"
    t.integer  "git_id"
    t.string   "avatar_url"
    t.string   "url"
    t.string   "html_url"
    t.string   "name"
    t.string   "company"
    t.string   "blog"
    t.string   "location"
    t.string   "email"
    t.string   "bio"
    t.boolean  "hireable"
    t.integer  "public_repos"
    t.integer  "public_gists"
    t.integer  "followers"
    t.integer  "following"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

end
