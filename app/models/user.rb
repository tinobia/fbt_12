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
  devise :omniauthable, omniauth_providers: %i(facebook google_oauth2)

  has_attached_file :avatar, styles: {medium: Settings.medium_image_size,
                                      thumb: Settings.avatar_thumb_image_size},
    default_url: Settings.placeholder_path
  validates_attachment_content_type :avatar, content_type: %r{\Aimage/.*\z}

  alias is? ==

  def liked? review
    likes.exists? review: review
  end

  class << self
    def from_omniauth auth
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.username = auth.info.email
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.first_name = auth.info.name.split(" ", 2)[0]
        user.last_name = auth.info.name.split(" ", 2)[1]
        user.avatar = URI.parse auth.info.image
        user.skip_confirmation!
      end
    end
  end
end
