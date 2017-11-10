class CreateTrips < ActiveRecord::Migration[5.1]
  def change
    create_table :trips do |t|
      t.datetime :from
      t.datetime :to
      t.integer :max_people, default: 0
      t.integer :total_people, default: 0
      t.bigint :price, default: 0
      t.boolean :active, default: false
      t.references :tour, foreign_key: true

      t.timestamps
    end
  end
end
