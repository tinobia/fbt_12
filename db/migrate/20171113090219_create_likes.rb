class CreateLikes < ActiveRecord::Migration[5.1]
  def change
    create_table :likes do |t|
      t.references :user, foreign_key: true
      t.references :review, foreign_key: true

      t.timestamps
    end

    add_index :likes, %i(user_id review_id), unique: true
  end
end
