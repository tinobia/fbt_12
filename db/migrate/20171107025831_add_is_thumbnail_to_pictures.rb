class AddIsThumbnailToPictures < ActiveRecord::Migration[5.1]
  def change
    add_column :pictures, :is_thumbnail, :boolean
  end
end
