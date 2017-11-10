class AddCategoryToTours < ActiveRecord::Migration[5.1]
  def change
    add_reference :tours, :category, foreign_key: true
  end
end
