class ChangeAvgStarsColumnOnTours < ActiveRecord::Migration[5.1]
  def change
    change_column :tours, :avg_stars, :decimal, precision: 3, scale: 1
  end
end
