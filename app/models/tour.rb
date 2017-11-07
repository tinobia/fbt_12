class Tour < ApplicationRecord
  validates :avg_stars,
    numericality: {greater_than: 0, less_than_or_equal_to: 5},
    allow_nil: true
  validates :arrival, presence: true
  validates :departure, presence: true
  validates :itinerary, presence: true
  validates :overview, presence: true
end
