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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130805203030) do

  create_table "games", :force => true do |t|
    t.date     "date"
    t.string   "away"
    t.string   "home"
    t.string   "time"
    t.string   "result"
    t.string   "season"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "goalies", :force => true do |t|
    t.string   "name"
    t.integer  "age"
    t.string   "team_abbrev"
    t.integer  "gp"
    t.integer  "w"
    t.integer  "l"
    t.integer  "otl"
    t.integer  "ga"
    t.integer  "sa"
    t.integer  "sv"
    t.float    "sv_perc"
    t.float    "gaa"
    t.integer  "shutouts"
    t.integer  "min"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "player_favorites", :force => true do |t|
    t.integer  "user_id"
    t.integer  "player_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "players", :force => true do |t|
    t.string   "name"
    t.string   "team_abbrev"
    t.integer  "gp"
    t.integer  "g"
    t.integer  "a"
    t.integer  "blocks"
    t.integer  "pts"
    t.integer  "plus_minus"
    t.integer  "pim"
    t.integer  "ppg"
    t.integer  "shots"
    t.float    "shot_perc"
    t.float    "fo_perc"
    t.integer  "hits"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "team_favorites", :force => true do |t|
    t.integer  "user_id"
    t.string   "team_abbrev"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.string   "abbrev"
    t.integer  "gp"
    t.integer  "wins"
    t.integer  "losses"
    t.integer  "ot_losses"
    t.integer  "points"
    t.float    "point_perc"
    t.float    "gpg"
    t.float    "gapg"
    t.float    "pp_perc"
    t.float    "pk_perc"
    t.float    "spg"
    t.float    "sapg"
    t.float    "faceoff_perc"
    t.string   "background_color"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "background_file_name"
    t.string   "background_content_type"
    t.integer  "background_file_size"
    t.datetime "background_updated_at"
    t.string   "players_pic_file_name"
    t.string   "players_pic_content_type"
    t.integer  "players_pic_file_size"
    t.datetime "players_pic_updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username",               :default => "", :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
