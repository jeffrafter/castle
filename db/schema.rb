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

ActiveRecord::Schema.define(:version => 20090922050804) do

  create_table "channels", :force => true do |t|
    t.string   "title"
    t.string   "subtitle"
    t.string   "keywords"
    t.text     "description"
    t.datetime "modified_at"
    t.boolean  "active",      :default => true,  :null => false
    t.integer  "region_id",                      :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "system",      :default => false
    t.boolean  "emergency",   :default => false
  end

  add_index "channels", ["region_id", "active", "modified_at"], :name => "index_channels_on_region_id_and_active_and_modified_at"

  create_table "commands", :force => true do |t|
    t.string   "word",       :null => false
    t.string   "key",        :null => false
    t.string   "locale",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commands", ["word", "key", "locale"], :name => "index_commands_on_word_and_key_and_locale"

  create_table "conversation_messages", :force => true do |t|
    t.integer "conversation_id"
    t.integer "inbox_id"
  end

  create_table "conversations", :force => true do |t|
    t.integer  "handler_id"
    t.integer  "user_id"
    t.string   "state"
    t.datetime "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deliveries", :force => true do |t|
    t.integer  "entry_id"
    t.integer  "channel_id"
    t.integer  "user_id"
    t.boolean  "read",       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deliveries", ["channel_id"], :name => "index_deliveries_on_channel_id"
  add_index "deliveries", ["created_at"], :name => "index_deliveries_on_created_at"
  add_index "deliveries", ["entry_id", "channel_id", "user_id", "created_at"], :name => "index_deliveries_on_entry_id_and_channel_id_and_user_id_and_created_at"
  add_index "deliveries", ["entry_id"], :name => "index_deliveries_on_entry_id"
  add_index "deliveries", ["user_id"], :name => "index_deliveries_on_user_id"

  create_table "entries", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.string   "author"
    t.string   "summary"
    t.string   "message"
    t.string   "checksum"
    t.text     "content"
    t.string   "categories"
    t.datetime "published_at"
    t.integer  "feed_id",                         :null => false
    t.boolean  "processed",    :default => false, :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entries", ["feed_id", "published_at"], :name => "index_entries_on_feed_id_and_published_at"
  add_index "entries", ["feed_id"], :name => "index_entries_on_feed_id"

  create_table "feeds", :force => true do |t|
    t.integer  "channel_id",                      :null => false
    t.string   "feed_url"
    t.string   "url"
    t.string   "etag"
    t.string   "title"
    t.string   "subtitle"
    t.text     "description"
    t.datetime "last_modified"
    t.string   "checksum"
    t.integer  "interval",      :default => 10,   :null => false
    t.datetime "stale_at"
    t.datetime "deleted_at"
    t.boolean  "active",        :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feeds", ["channel_id", "active"], :name => "index_feeds_on_channel_id_and_active"
  add_index "feeds", ["feed_url"], :name => "index_feeds_on_feed_url"

  create_table "gateways", :force => true do |t|
    t.string   "number"
    t.integer  "short_code"
    t.integer  "country_code"
    t.integer  "area_code"
    t.boolean  "active"
    t.string   "api_key",            :limit => 128
    t.datetime "api_key_expires_at"
    t.integer  "region_id",                                                :null => false
    t.string   "locale",                            :default => "en",      :null => false
    t.integer  "timezone_offset",                                          :null => false
    t.string   "number_format",                     :default => "\\d{10}", :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "delay",                             :default => 60
  end

  add_index "gateways", ["api_key", "api_key_expires_at"], :name => "index_gateways_on_api_key_and_api_key_expires_at"
  add_index "gateways", ["country_code", "area_code"], :name => "index_gateways_on_country_code_and_area_code"
  add_index "gateways", ["number"], :name => "index_gateways_on_number"
  add_index "gateways", ["region_id"], :name => "index_gateways_on_region_id"
  add_index "gateways", ["short_code"], :name => "index_gateways_on_short_code"

  create_table "inbox", :force => true do |t|
    t.string   "text"
    t.string   "number"
    t.integer  "reply_to"
    t.integer  "gateway_id"
    t.string   "receiver"
    t.datetime "sent_at"
    t.datetime "processed_at"
    t.boolean  "handled"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "charge",       :default => 0.0
  end

  create_table "outbox", :force => true do |t|
    t.string   "text"
    t.string   "number"
    t.integer  "reply_to"
    t.integer  "gateway_id"
    t.boolean  "sent"
    t.datetime "sent_at"
    t.boolean  "receipt"
    t.datetime "received_at"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "priority",    :default => 1
    t.string   "status"
    t.float    "charge",      :default => 0.0
  end

  create_table "popular", :force => true do |t|
    t.integer  "channel_id", :null => false
    t.integer  "entry_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "entry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "region_id"
  end

  create_table "regions", :force => true do |t|
    t.string   "name",                         :null => false
    t.string   "country",                      :null => false
    t.boolean  "active",     :default => true, :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "regions", ["country"], :name => "index_regions_on_country"
  add_index "regions", ["name"], :name => "index_regions_on_name"

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "channel_id"
    t.boolean  "want_all",       :default => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number_per_day", :default => 3
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.boolean  "email_confirmed",                          :default => false,                 :null => false
    t.string   "encrypted_password",        :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "token",                     :limit => 128
    t.datetime "token_expires_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "number"
    t.boolean  "number_confirmed",                         :default => false,                 :null => false
    t.integer  "gateway_id"
    t.integer  "timezone_offset",                          :default => 0,                     :null => false
    t.integer  "awake",                                    :default => 8,                     :null => false
    t.integer  "sleep",                                    :default => 22,                    :null => false
    t.string   "locale"
    t.boolean  "active",                                   :default => true,                  :null => false
    t.datetime "deleted_at"
    t.string   "name"
    t.string   "address"
    t.string   "provider"
    t.boolean  "prepaid",                                  :default => false
    t.string   "details"
    t.integer  "delay",                                    :default => 60
    t.datetime "created_at",                               :default => '2009-07-31 09:13:05'
    t.datetime "updated_at",                               :default => '2009-07-31 09:13:05'
    t.string   "confirmation_token",        :limit => 128
  end

  add_index "users", ["email", "encrypted_password"], :name => "index_users_on_email_and_encrypted_password"
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["id", "confirmation_token"], :name => "index_users_on_id_and_confirmation_token"
  add_index "users", ["id", "salt"], :name => "index_users_on_id_and_salt"
  add_index "users", ["id", "token"], :name => "index_users_on_id_and_token"
  add_index "users", ["number"], :name => "index_users_on_number"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"
  add_index "users", ["token"], :name => "index_users_on_token"

end
