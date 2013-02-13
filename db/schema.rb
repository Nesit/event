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

ActiveRecord::Schema.define(:version => 20130213183010) do

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

  create_table "article_authors", :force => true do |t|
    t.string   "avatar"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "article_body_images", :force => true do |t|
    t.string   "source"
    t.integer  "article_gallery_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "article_body_images", ["article_gallery_id"], :name => "index_article_body_images_on_article_id"

  create_table "article_galleries", :force => true do |t|
    t.integer  "article_id"
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "article_galleries", ["article_id"], :name => "index_article_galleries_on_article_id"

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "type"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.text     "short_description"
    t.string   "head_image"
    t.datetime "target_at"
    t.string   "list_item_description"
    t.integer  "author_id"
    t.integer  "issue_id"
    t.boolean  "closed",                :default => false, :null => false
    t.text     "closed_body"
    t.integer  "comments_count",        :default => 0
    t.integer  "pageviews_count",       :default => 0
    t.string   "head_video_code"
    t.integer  "vk_shares_count",       :default => 0
    t.integer  "fb_shares_count",       :default => 0
    t.integer  "twitter_shares_count",  :default => 0
    t.integer  "gplus_shares_count",    :default => 0
    t.integer  "mailru_shares_count",   :default => 0
    t.datetime "published_at"
    t.string   "head_video_kind"
    t.boolean  "published",             :default => true
    t.string   "slug"
  end

  add_index "articles", ["issue_id"], :name => "index_articles_on_issue_id"
  add_index "articles", ["pageviews_count"], :name => "index_articles_on_pageviews_count"
  add_index "articles", ["published_at"], :name => "index_articles_on_published_at"
  add_index "articles", ["slug"], :name => "index_articles_on_slug", :unique => true
  add_index "articles", ["target_at"], :name => "index_articles_on_target_at"
  add_index "articles", ["type"], :name => "index_articles_on_type"

  create_table "assets", :force => true do |t|
    t.string   "storage"
    t.string   "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "dimensions"
  end

  create_table "authentications", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "provider",   :null => false
    t.string   "uid",        :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cities", :force => true do |t|
    t.integer  "country_cd"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "cities", ["country_cd"], :name => "index_cities_on_country_cd"

  create_table "comments", :force => true do |t|
    t.integer  "author_id"
    t.text     "body"
    t.string   "ancestry"
    t.integer  "topic_id"
    t.string   "topic_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "comments", ["ancestry"], :name => "index_comments_on_ancestry"
  add_index "comments", ["author_id"], :name => "index_comments_on_author_id"
  add_index "comments", ["topic_id"], :name => "index_comments_on_topic_id"
  add_index "comments", ["topic_type"], :name => "index_comments_on_topic_type"

  create_table "issues", :force => true do |t|
    t.date     "issued_at"
    t.string   "cover"
    t.string   "name"
    t.integer  "number"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "slug"
  end

  add_index "pages", ["slug"], :name => "index_pages_on_slug", :unique => true

  create_table "poll_choices", :force => true do |t|
    t.integer  "poll_id"
    t.string   "title"
    t.integer  "votes_count", :default => 0
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "poll_choices", ["poll_id"], :name => "index_poll_choices_on_poll_id"

  create_table "poll_votes", :force => true do |t|
    t.integer  "poll_id"
    t.integer  "poll_choice_id"
    t.integer  "user_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "poll_votes", ["poll_choice_id"], :name => "index_poll_votes_on_poll_choice_id"
  add_index "poll_votes", ["poll_id"], :name => "index_poll_votes_on_poll_id"
  add_index "poll_votes", ["user_id"], :name => "index_poll_votes_on_user_id"

  create_table "polls", :force => true do |t|
    t.datetime "start_at"
    t.datetime "end_at"
    t.string   "topic"
    t.integer  "comments_count",       :default => 0
    t.integer  "pageviews_count",      :default => 0
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "vk_shares_count",      :default => 0
    t.integer  "fb_shares_count",      :default => 0
    t.integer  "twitter_shares_count", :default => 0
    t.integer  "gplus_shares_count",   :default => 0
    t.integer  "mailru_shares_count",  :default => 0
    t.datetime "published_at"
    t.string   "slug"
  end

  add_index "polls", ["published_at"], :name => "index_polls_on_published_at"
  add_index "polls", ["slug"], :name => "index_polls_on_slug", :unique => true

  create_table "site_configs", :force => true do |t|
    t.integer  "actual_article_id"
    t.text     "actual_article_description"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "article_list_banner_after"
    t.text     "article_list_banner_body"
    t.text     "bottom_menu"
    t.text     "top_menu"
  end

  create_table "subscriptions", :force => true do |t|
    t.date     "activated_at"
    t.date     "ended_at"
    t.integer  "kind_cd"
    t.boolean  "print_versions_by_courier", :default => false, :null => false
    t.integer  "user_id"
    t.string   "state"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  add_index "subscriptions", ["state"], :name => "index_subscriptions_on_state"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "state"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "activation_state"
    t.string   "activation_token"
    t.datetime "activation_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.string   "name"
    t.string   "avatar"
    t.date     "born_at"
    t.integer  "gender_cd"
    t.string   "company"
    t.string   "position"
    t.string   "website"
    t.string   "phone_number"
    t.integer  "city_id"
    t.boolean  "active_subscription",             :default => false, :null => false
    t.boolean  "article_comment_notification",    :default => true,  :null => false
    t.boolean  "comment_notification",            :default => true,  :null => false
    t.boolean  "event_notification",              :default => true,  :null => false
    t.boolean  "partner_notification",            :default => true,  :null => false
    t.boolean  "weekly_notification",             :default => true,  :null => false
    t.string   "merge_token"
    t.string   "merge_email"
    t.datetime "merge_token_expires_at"
  end

  add_index "users", ["activation_token"], :name => "index_users_on_activation_token"
  add_index "users", ["city_id"], :name => "index_users_on_city_id"
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["merge_token"], :name => "index_users_on_merge_token"
  add_index "users", ["remember_me_token"], :name => "index_users_on_remember_me_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"
  add_index "users", ["state"], :name => "index_users_on_state"

end
