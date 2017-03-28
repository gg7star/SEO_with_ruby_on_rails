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

ActiveRecord::Schema.define(version: 20170315230249) do

  create_table "bookmarks", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.bigint   "user_id",    null: false
    t.bigint   "result_id",  null: false
    t.string   "ticker",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "expandedresults", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "ticker"
    t.string   "country"
    t.datetime "pubDate"
    t.string   "url"
    t.string   "title"
    t.text     "rawText",        limit: 4294967295
    t.float    "sentimentScore", limit: 53
    t.float    "targetedScore",  limit: 53
    t.string   "targeted_type"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "migrations", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string  "migration", null: false
    t.integer "batch",     null: false
  end

  create_table "news", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "ticker",        limit: 65535
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.datetime "pubDate"
    t.string   "url"
    t.text     "subject",       limit: 65535
    t.text     "rawText",       limit: 4294967295
    t.float    "keyword_score", limit: 53
  end

  create_table "password_resets", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "email",      null: false
    t.string   "token",      null: false
    t.datetime "created_at"
    t.index ["email"], name: "password_resets_email_index", using: :btree
    t.index ["token"], name: "password_resets_token_index", using: :btree
  end

  create_table "results", unsigned: true, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "ticker",                            null: false
    t.datetime "pubDate",                           null: false
    t.string   "country",                                        collation: "utf8_general_ci"
    t.string   "url",            limit: 1000,       null: false
    t.string   "title",          limit: 1000
    t.text     "rawText",        limit: 4294967295
    t.text     "cleanText",      limit: 65535
    t.float    "sentimentScore", limit: 53
    t.float    "targetedScore",  limit: 53
    t.string   "targeted_type"
    t.string   "sourceType"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["pubDate"], name: "results_pubdate_index", using: :btree
    t.index ["ticker"], name: "results_ticker_index", using: :btree
    t.index ["title", "rawText"], name: "full", type: :fulltext
  end

  create_table "stocks", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "ticker",                             null: false
    t.string   "companyName",                        null: false
    t.text     "searchString",    limit: 4294967295, null: false
    t.datetime "lastRunDate",                        null: false
    t.datetime "lastMessageTime",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "pubDate",         limit: 24
    t.string   "url"
    t.string   "title"
    t.text     "rawText",         limit: 4294967295
    t.index ["ticker"], name: "stocks_ticker_index", using: :btree
  end

  create_table "targets", unsigned: true, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "ticker",                        null: false
    t.string   "url",              limit: 1000, null: false
    t.string   "targetedKeywords",                           collation: "utf8_general_ci"
    t.datetime "pubDate"
    t.float    "sentimentScore",   limit: 24
    t.string   "targetedScore"
    t.string   "targeted_type"
    t.float    "MovAvg",           limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["ticker"], name: "results_ticker_index", using: :btree
  end

  create_table "temp", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "ttype", limit: 45
  end

  create_table "users", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name",                                       null: false
    t.string   "email",                                      null: false
    t.string   "password",                                   null: false
    t.boolean  "is_admin",                   default: false, null: false
    t.integer  "allowed_demo",   limit: 1,   default: 0,     null: false, comment: "0=>No, 1=>Yes"
    t.string   "remember_token", limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "users_email_unique", unique: true, using: :btree
  end

end
