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

ActiveRecord::Schema.define(version: 20171025191525) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "distinction_tiers", force: :cascade do |t|
    t.string   "label",       null: false
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "languages", force: :cascade do |t|
    t.string   "code",       null: false
    t.string   "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lemma_comments", force: :cascade do |t|
    t.integer  "lemma_id"
    t.string   "field"
    t.string   "content",                                       null: false
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",    default: '2017-10-19 18:21:35', null: false
    t.datetime "updated_at",    default: '2017-10-19 18:21:35', null: false
    t.index ["created_by_id"], name: "index_lemma_comments_on_created_by_id", using: :btree
    t.index ["field"], name: "index_lemma_comments_on_field", using: :btree
    t.index ["lemma_id"], name: "index_lemma_comments_on_lemma_id", using: :btree
    t.index ["updated_by_id"], name: "index_lemma_comments_on_updated_by_id", using: :btree
  end

  create_table "lemmas", force: :cascade do |t|
    t.string   "label",                            null: false
    t.string   "article"
    t.string   "meaning"
    t.string   "loan_word_form"
    t.string   "source"
    t.string   "reference"
    t.boolean  "activated",         default: true
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "language_id"
    t.integer  "part_of_speech_id"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.index ["created_by_id"], name: "index_lemmas_on_created_by_id", using: :btree
    t.index ["language_id"], name: "index_lemmas_on_language_id", using: :btree
    t.index ["part_of_speech_id"], name: "index_lemmas_on_part_of_speech_id", using: :btree
    t.index ["updated_by_id"], name: "index_lemmas_on_updated_by_id", using: :btree
  end

  create_table "lemmas_semantic_fields", id: false, force: :cascade do |t|
    t.integer "semantic_field_id"
    t.integer "lemma_id"
    t.index ["lemma_id"], name: "index_lemmas_semantic_fields_on_lemma_id", using: :btree
    t.index ["semantic_field_id"], name: "index_lemmas_semantic_fields_on_semantic_field_id", using: :btree
  end

  create_table "part_of_speeches", force: :cascade do |t|
    t.string   "label",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "semantic_fields", force: :cascade do |t|
    t.string   "label",      null: false
    t.string   "url"
    t.string   "source",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sublemma_comments", force: :cascade do |t|
    t.integer  "sublemma_id"
    t.string   "field"
    t.text     "content"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.index ["created_by_id"], name: "index_sublemma_comments_on_created_by_id", using: :btree
    t.index ["field"], name: "index_sublemma_comments_on_field", using: :btree
    t.index ["sublemma_id"], name: "index_sublemma_comments_on_sublemma_id", using: :btree
    t.index ["updated_by_id"], name: "index_sublemma_comments_on_updated_by_id", using: :btree
  end

  create_table "sublemmas", force: :cascade do |t|
    t.string   "label",                            null: false
    t.integer  "part_of_speech_id"
    t.integer  "language_id"
    t.integer  "lemma_id"
    t.string   "hierarchy"
    t.string   "loaned_form"
    t.boolean  "activated",         default: true
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.index ["created_by_id"], name: "index_sublemmas_on_created_by_id", using: :btree
    t.index ["language_id"], name: "index_sublemmas_on_language_id", using: :btree
    t.index ["lemma_id"], name: "index_sublemmas_on_lemma_id", using: :btree
    t.index ["part_of_speech_id"], name: "index_sublemmas_on_part_of_speech_id", using: :btree
    t.index ["updated_by_id"], name: "index_sublemmas_on_updated_by_id", using: :btree
  end

  create_table "usage_categories", force: :cascade do |t|
    t.string   "code",       null: false
    t.string   "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_usage_categories_on_code", unique: true, using: :btree
  end

  create_table "usage_categories_usages", id: false, force: :cascade do |t|
    t.integer "usage_id",          null: false
    t.integer "usage_category_id", null: false
    t.index ["usage_category_id"], name: "index_usage_categories_usages_on_usage_category_id", using: :btree
    t.index ["usage_id"], name: "index_usage_categories_usages_on_usage_id", using: :btree
  end

  create_table "usages", force: :cascade do |t|
    t.string   "coptic_specification"
    t.string   "meaning"
    t.string   "hierarchy"
    t.integer  "distinction_tier_id"
    t.integer  "sublemma_id"
    t.string   "criterion"
    t.integer  "corresponding_usages", default: [],              array: true
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.index ["created_by_id"], name: "index_usages_on_created_by_id", using: :btree
    t.index ["distinction_tier_id"], name: "index_usages_on_distinction_tier_id", using: :btree
    t.index ["sublemma_id"], name: "index_usages_on_sublemma_id", using: :btree
    t.index ["updated_by_id"], name: "index_usages_on_updated_by_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "code",                           null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "role"
    t.string   "password_digest"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "activated",       default: true
    t.index ["code"], name: "index_users_on_code", unique: true, using: :btree
  end

  add_foreign_key "lemma_comments", "lemmas"
  add_foreign_key "lemma_comments", "users", column: "created_by_id"
  add_foreign_key "lemma_comments", "users", column: "updated_by_id"
  add_foreign_key "lemmas", "languages"
  add_foreign_key "lemmas", "part_of_speeches"
  add_foreign_key "lemmas", "users", column: "created_by_id"
  add_foreign_key "lemmas", "users", column: "updated_by_id"
  add_foreign_key "sublemma_comments", "sublemmas"
  add_foreign_key "sublemma_comments", "users", column: "created_by_id"
  add_foreign_key "sublemma_comments", "users", column: "updated_by_id"
  add_foreign_key "sublemmas", "languages"
  add_foreign_key "sublemmas", "lemmas"
  add_foreign_key "sublemmas", "part_of_speeches"
  add_foreign_key "sublemmas", "users", column: "created_by_id"
  add_foreign_key "sublemmas", "users", column: "updated_by_id"
  add_foreign_key "usages", "distinction_tiers"
  add_foreign_key "usages", "sublemmas"
  add_foreign_key "usages", "users", column: "created_by_id"
  add_foreign_key "usages", "users", column: "updated_by_id"
end
