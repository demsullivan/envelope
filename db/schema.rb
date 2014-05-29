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

ActiveRecord::Schema.define(:version => 20140528164829) do

  create_table "envelopes", :force => true do |t|
    t.string  "name"
    t.float   "weekly_amount"
    t.float   "balance"
    t.integer "last_txn_id"
    t.string  "mint_categories"
  end

  create_table "transactions", :force => true do |t|
    t.string  "bank"
    t.string  "account"
    t.date    "date"
    t.string  "category"
    t.string  "merchant"
    t.float   "amount"
    t.integer "mint_id"
    t.integer "envelope_id"
  end

end
