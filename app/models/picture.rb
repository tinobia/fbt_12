class Picture < ApplicationRecord
  belongs_to :tour

  has_attached_file :image, styles: {medium: Settings.medium_image_size,
                                     thumb: Settings.thumb_image_size}
  validates_attachment_content_type :image, content_type: %r{\Aimage/.*\z}
end
