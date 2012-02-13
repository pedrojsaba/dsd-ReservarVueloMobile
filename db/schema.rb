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

ActiveRecord::Schema.define(:version => 20120213015541) do

  create_table "flights", :force => true do |t|
    t.string   "codigo"
    t.string   "aerolinea"
    t.datetime "salida"
    t.datetime "llegada"
    t.string   "ciudad"
    t.boolean  "estado"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "passengers", :force => true do |t|
    t.string   "user"
    t.string   "password"
    t.string   "password_reply"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seats", :force => true do |t|
    t.integer  "id_asiento"
    t.integer  "numero"
    t.string   "posicion"
    t.integer  "flight_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
