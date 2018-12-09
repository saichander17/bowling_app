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

ActiveRecord::Schema.define(version: 20181208091454) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_sets", force: :cascade do |t|
    t.string   "name"
    t.integer  "plays"
    t.integer  "game_id"
    t.integer  "player_id"
    t.text     "pins_dropped",              default: [],              array: true
    t.text     "extra_chance_pins_dropped", default: [],              array: true
    t.integer  "set_number"
    t.integer  "no_of_pins"
    t.float    "strike_bonus"
    t.float    "spare_bonus"
    t.float    "score_per_pin"
    t.float    "bonus_score"
    t.integer  "extra_chances_for_spare"
    t.integer  "extra_chances_for_strike"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "games", force: :cascade do |t|
    t.integer  "lane_id"
    t.text     "player_ids",            default: [],                 array: true
    t.integer  "total_no_of_sets"
    t.boolean  "players_go_one_by_one", default: false
    t.datetime "finished_at"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "lanes", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leader_boards", force: :cascade do |t|
    t.integer  "game_id"
    t.integer  "player_id"
    t.integer  "rank"
    t.float    "total_score"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.string   "identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
