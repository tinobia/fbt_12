class CreateTours < ActiveRecord::Migration[5.1]
  def change
    create_table :tours do |t|
      t.string :name
      t.string :departure
      t.string :arrival
      t.decimal :avg_stars, precision: 2, scale: 1
      t.text :itinerary
      t.text :overview

      t.timestamps
    end
  end
end
