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

ActiveRecord::Schema.define(:version => 20130115065616) do

  create_table "airings", :force => true do |t|
    t.integer  "video_id"
    t.integer  "channel_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "position"
    t.string   "state"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
  end

  add_index "airings", ["channel_id"], :name => "index_airings_on_channel_id"
  add_index "airings", ["position"], :name => "index_airings_on_position"

  create_table "authentications", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "provider",   :null => false
    t.string   "uid",        :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "token"
  end

  add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"

  create_table "channels", :force => true do |t|
    t.integer  "creator_id"
    t.string   "title"
    t.string   "description"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "subscriptions_count", :default => 0
    t.string   "cover_art"
    t.string   "random_string"
    t.string   "type"
    t.boolean  "private"
    t.integer  "score"
    t.string   "slug",                :default => "", :null => false
  end

  add_index "channels", ["creator_id"], :name => "index_channels_on_creator_id"
  add_index "channels", ["slug"], :name => "index_channels_on_slug", :unique => true

  create_table "likes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "likeable_id"
    t.string   "likeable_type"
    t.boolean  "like_flag"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "likes", ["likeable_id", "likeable_type"], :name => "index_likes_on_likeable_id_and_likeable_type"

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "channel_id"
    t.string   "level"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "read_marks", :force => true do |t|
    t.integer  "readable_id"
    t.integer  "user_id",                     :null => false
    t.string   "readable_type", :limit => 20, :null => false
    t.datetime "timestamp"
  end

  add_index "read_marks", ["user_id", "readable_type", "readable_id"], :name => "index_read_marks_on_user_id_and_readable_type_and_readable_id"

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "channel_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "unread_count", :default => 0
  end

  add_index "subscriptions", ["user_id"], :name => "index_subscriptions_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "username",                        :null => false
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.string   "activation_state"
    t.string   "activation_token"
    t.datetime "activation_token_expires_at"
  end

  add_index "users", ["activation_token"], :name => "index_users_on_activation_token"
  add_index "users", ["remember_me_token"], :name => "index_users_on_remember_me_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"

  create_table "users_channels", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "channel_id"
  end

  create_table "videos", :force => true do |t|
    t.integer  "channel_id"
    t.integer  "owner_id"
    t.integer  "airings_count"
    t.string   "title"
    t.text     "body"
    t.text     "description"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "source_name"
    t.string   "source_id"
    t.string   "source_url"
    t.string   "source_author_name"
    t.string   "provider_object_id"
    t.string   "provider_user_name"
    t.string   "provider_user_image"
    t.string   "provider_user_nick"
    t.string   "provider_user_id"
    t.string   "provider_thumbnail_url"
    t.integer  "provider_thumbnail_width"
    t.integer  "provider_thumbnail_height"
  end

end
