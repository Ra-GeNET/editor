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

ActiveRecord::Schema.define(version: 20140202103924) do

  create_table "extmaps", force: true do |t|
    t.string   "suffix"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "noedit"
    t.boolean  "noindex"
    t.string   "category"
    t.integer  "lang_id"
    t.integer  "priority"
  end

  create_table "fiddles", force: true do |t|
    t.string   "title"
    t.text     "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "langcode"
    t.string   "skin"
    t.string   "fontsize"
    t.string   "lineheight"
    t.string   "preview_url"
    t.string   "file_path"
    t.string   "folder"
    t.boolean  "noindex"
    t.datetime "deleted_at"
    t.string   "category"
    t.integer  "lang_id"
    t.integer  "site_id"
    t.boolean  "modified"
  end

  create_table "langs", force: true do |t|
    t.string   "title"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "content_type"
    t.string   "category"
  end

  create_table "sites", force: true do |t|
    t.string   "file_path"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skins", force: true do |t|
    t.string   "title"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
