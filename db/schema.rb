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

ActiveRecord::Schema.define(version: 20140730000000) do

  create_table "bank_branches", force: true do |t|
    t.integer  "bank_id",                            null: false
    t.integer  "zengin_code", limit: 2,              null: false
    t.string   "name",        limit: 64,             null: false
    t.string   "name_kana",   limit: 64,             null: false
    t.integer  "show_order",             default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bank_branches", ["bank_id", "name"], name: "index_bank_branches_on_bank_id_and_name", unique: true, using: :btree
  add_index "bank_branches", ["bank_id", "name_kana"], name: "index_bank_branches_on_bank_id_and_name_kana", unique: true, using: :btree
  add_index "bank_branches", ["bank_id", "zengin_code", "show_order"], name: "index_bank_branches_on_bank_id_and_zengin_code_and_show_order", unique: true, using: :btree
  add_index "bank_branches", ["name_kana"], name: "index_bank_branches_on_name_kana", using: :btree

  create_table "banks", force: true do |t|
    t.integer  "zengin_code", limit: 2,  null: false
    t.string   "name",        limit: 64, null: false
    t.string   "name_kana",   limit: 64, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "banks", ["name"], name: "index_banks_on_name", unique: true, using: :btree
  add_index "banks", ["name_kana"], name: "index_banks_on_name_kana", using: :btree
  add_index "banks", ["zengin_code"], name: "index_banks_on_zengin_code", unique: true, using: :btree

end
