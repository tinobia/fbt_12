class Review < ApplicationRecord
  belongs_to :user
  belongs_to :tour
  has_many :likes, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :content, presence: true
  validates :stars, presence: true

  after_save :update_avg_stars
  after_destroy ->{update_avg_stars true}

  scope :order_by_created_at, ->{order(created_at: :desc)}

  delegate :username, to: :user
  delegate :avatar, to: :user, prefix: true

  def like_count
    likes.size
  end

  def like_by user
    likes.create user: user
  rescue ActiveRecordError
    false
  end

  def unlike_by user
    likes.of_user(user).destroy_all.size.positive?
  end

  private

  def update_avg_stars destroyed
    return unless destroyed || saved_change_to_stars?
    tour.update_attributes avg_stars: tour.reviews.average(:stars)
  end
end
