class CreateBookingRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :booking_requests do |t|
      t.bigint :price, default: 0
      t.integer :number_of_people, default: 0
      t.integer :status, default: 0
      t.references :user, foreign_key: true
      t.references :trip, foreign_key: true

      t.timestamps
    end
  end
end
