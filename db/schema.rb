# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 8) do

  create_table "areas", :force => true do |t|
    t.string   "name",         :null => false
    t.integer  "country_code", :null => false
    t.integer  "area_code",    :null => false
    t.integer  "region_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "areas", ["country_code", "area_code"], :name => "index_areas_on_country_code_and_area_code"
  add_index "areas", ["name"], :name => "index_areas_on_name"
  add_index "areas", ["region_id"], :name => "index_areas_on_region_id"

  create_table "channels", :force => true do |t|
    t.string   "title"
    t.string   "subtitle"
    t.string   "link",                          :null => false
    t.text     "description"
    t.string   "author"
    t.integer  "interval"
    t.datetime "updated_at"
    t.boolean  "active",      :default => true, :null => false
    t.integer  "region_id",                     :null => false
    t.datetime "created_at"
  end

  add_index "channels", ["link"], :name => "index_channels_on_link"
  add_index "channels", ["region_id", "active"], :name => "index_channels_on_region_id_and_active"

  create_table "entries", :force => true do |t|
    t.string   "title"
    t.string   "summary"
    t.string   "link"
    t.string   "author"
    t.string   "contributor"
    t.text     "description"
    t.text     "content"
    t.string   "category"
    t.string   "uuid"
    t.datetime "published_at"
    t.datetime "updated_at"
    t.datetime "expires_at"
    t.integer  "channel_id",   :null => false
    t.datetime "created_at"
  end

  add_index "entries", ["channel_id", "updated_at"], :name => "index_entries_on_channel_id_and_updated_at"
  add_index "entries", ["channel_id"], :name => "index_entries_on_channel_id"

  create_table "gateways", :force => true do |t|
    t.string   "number"
    t.integer  "short_code"
    t.integer  "country_code"
    t.integer  "area_code"
    t.boolean  "active"
    t.integer  "region_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gateways", ["country_code", "area_code"], :name => "index_gateways_on_country_code_and_area_code"
  add_index "gateways", ["number"], :name => "index_gateways_on_number"
  add_index "gateways", ["region_id"], :name => "index_gateways_on_region_id"
  add_index "gateways", ["short_code"], :name => "index_gateways_on_short_code"

  create_table "keywords", :force => true do |t|
    t.string   "word",        :null => false
    t.text     "description"
    t.string   "language",    :null => false
    t.integer  "channel_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "keywords", ["channel_id"], :name => "index_keywords_on_channel_id"
  add_index "keywords", ["word", "language"], :name => "index_keywords_on_word_and_language"

  create_table "messages", :force => true do |t|
    t.string   "message"
    t.string   "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regions", :force => true do |t|
    t.string   "name",                         :null => false
    t.string   "country",                      :null => false
    t.string   "language",                     :null => false
    t.boolean  "active",     :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "regions", ["country"], :name => "index_regions_on_country"
  add_index "regions", ["name"], :name => "index_regions_on_name"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.boolean  "email_confirmed",                          :default => false, :null => false
    t.string   "encrypted_password",        :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "token",                     :limit => 128
    t.datetime "token_expires_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "number"
    t.boolean  "number_confirmed",                         :default => false, :null => false
    t.boolean  "active",                                   :default => true,  :null => false
  end

  add_index "users", ["email", "encrypted_password"], :name => "index_users_on_email_and_encrypted_password"
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["id", "salt"], :name => "index_users_on_id_and_salt"
  add_index "users", ["id", "token"], :name => "index_users_on_id_and_token"
  add_index "users", ["number"], :name => "index_users_on_number"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"
  add_index "users", ["token"], :name => "index_users_on_token"

end
