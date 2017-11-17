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

ActiveRecord::Schema.define(version: 20171113085324) do

  create_table "booking_requests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "price", default: 0
    t.integer "number_of_people", default: 0
    t.integer "status", default: 0
    t.bigint "user_id"
    t.bigint "trip_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trip_id"], name: "index_booking_requests_on_trip_id"
    t.index ["user_id"], name: "index_booking_requests_on_user_id"
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ckeditor_assets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "data_fingerprint"
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "pictures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.bigint "tour_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_thumbnail"
    t.index ["tour_id"], name: "index_pictures_on_tour_id"
  end

  create_table "reviews", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "stars"
    t.text "content"
    t.bigint "user_id"
    t.bigint "tour_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tour_id"], name: "index_reviews_on_tour_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "tours", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "departure"
    t.string "arrival"
    t.decimal "avg_stars", precision: 3, scale: 1
    t.text "itinerary"
    t.text "overview"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.index ["category_id"], name: "index_tours_on_category_id"
  end

  create_table "trips", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "from"
    t.datetime "to"
    t.integer "max_people", default: 0
    t.integer "total_people", default: 0
    t.bigint "price", default: 0
    t.boolean "active", default: false
    t.bigint "tour_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tour_id"], name: "index_trips_on_tour_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "username"
    t.string "password_digest"
    t.boolean "is_admin"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "activation_digest"
    t.string "remember_digest"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_foreign_key "booking_requests", "trips"
  add_foreign_key "booking_requests", "users"
  add_foreign_key "reviews", "tours"
  add_foreign_key "reviews", "users"
  add_foreign_key "tours", "categories"
  add_foreign_key "trips", "tours"
end
