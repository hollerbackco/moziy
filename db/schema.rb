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

ActiveRecord::Schema.define(:version => 20130205044930) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "activities", :force => true do |t|
    t.string   "event_type"
    t.string   "subject_type"
    t.string   "actor_type"
    t.string   "secondary_subject_type"
    t.integer  "subject_id"
    t.integer  "actor_id"
    t.integer  "secondary_subject_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "activities", ["actor_id", "actor_type"], :name => "index_activities_on_actor_id_and_actor_type"
  add_index "activities", ["secondary_subject_id", "secondary_subject_type"], :name => "index_activities_on_secondary_subject_id_and_type"
  add_index "activities", ["subject_id", "subject_type"], :name => "index_activities_on_subject_id_and_subject_type"

  create_table "add_video_requests", :force => true do |t|
    t.integer  "channel_id"
    t.string   "urls"
    t.string   "state"
    t.text     "msg"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "admin_users", :force => true do |t|
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

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

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

  create_table "channel_invites", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "channel_id"
    t.string   "recipient_email"
    t.string   "token"
    t.datetime "sent_at"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

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
    t.datetime "deleted_at"
    t.integer  "airings_count"
  end

  add_index "channels", ["creator_id"], :name => "index_channels_on_creator_id"
  add_index "channels", ["slug"], :name => "index_channels_on_slug", :unique => true

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "invite_codes", :force => true do |t|
    t.integer  "user_id"
    t.string   "state"
    t.string   "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "invite_codes", ["code"], :name => "index_invite_codes_on_code", :unique => true

  create_table "invite_requests", :force => true do |t|
    t.string   "email"
    t.string   "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "invite_requests", ["email"], :name => "index_invite_requests_on_email", :unique => true

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
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
    t.integer  "unread_count",         :default => 0
    t.datetime "last_added_airing_at", :default => '2013-01-25 23:39:45', :null => false
    t.integer  "last_played_id"
  end

  add_index "subscriptions", ["last_added_airing_at"], :name => "index_subscriptions_on_last_added_airing_at"
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
    t.integer  "primary_channel_id"
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
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "source_name"
    t.string   "source_id"
    t.string   "source_url"
    t.string   "video_image"
    t.string   "random_string"
    t.text     "source_meta"
  end

end
