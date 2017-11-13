class Review < ApplicationRecord
  belongs_to :user
  belongs_to :tour

  validates :content, presence: true
  validates :stars, presence: true

  after_save :update_avg_stars

  delegate :username, to: :user
  delegate :avatar, to: :user, prefix: true

  def update_avg_stars
    return unless saved_change_to_stars?
    tour.update_attributes avg_stars: tour.reviews.average(:stars)
  end
end
