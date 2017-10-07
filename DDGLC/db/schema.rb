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

ActiveRecord::Schema.define(version: 20171007200711) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "languages", force: :cascade do |t|
    t.string   "code"
    t.string   "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "part_of_speeches", force: :cascade do |t|
    t.string   "label"
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

  create_table "semantic_fields_lemmas", id: false, force: :cascade do |t|
    t.integer "semantic_field_id"
    t.integer "lemma_id"
    t.index ["lemma_id"], name: "index_semantic_fields_lemmas_on_lemma_id", using: :btree
    t.index ["semantic_field_id"], name: "index_semantic_fields_lemmas_on_semantic_field_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "code"
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

  add_foreign_key "lemmas", "languages"
  add_foreign_key "lemmas", "part_of_speeches"
  add_foreign_key "lemmas", "users", column: "created_by_id"
  add_foreign_key "lemmas", "users", column: "updated_by_id"
end
