class User < ApplicationRecord
  has_many :booking_requests, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :username, presence: true,
    length: {maximum: Settings.max_username_length,
             minimum: Settings.min_username_length},
    uniqueness: true
  validates :first_name, length: {maximum: Settings.max_first_name_length}
  validates :last_name, length: {maximum: Settings.max_last_name_length}

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :confirmable

  has_attached_file :avatar, styles: {medium: Settings.medium_image_size,
                                      thumb: Settings.avatar_thumb_image_size},
    default_url: Settings.placeholder_path
  validates_attachment_content_type :avatar, content_type: %r{\Aimage/.*\z}

  alias is? ==

  def liked? review
    likes.exists? review: review
  end
end
