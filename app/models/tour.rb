class Tour < ApplicationRecord
  attr_accessor :thumbnail_id

  belongs_to :category
  has_many :pictures, dependent: :destroy
  has_many :trips, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :avg_stars,
    numericality: {greater_than: Settings.lowest_star,
                   less_than_or_equal_to: Settings.highest_star},
    allow_nil: true
  validates :arrival, presence: true
  validates :departure, presence: true
  validates :itinerary, presence: true
  validates :overview, presence: true
  validate :must_have_one_thumbnail

  scope :under_these_categories,
    ->(categories){where("category_id IN (#{categories})")}
  scope :order_by_created_at, ->{order(created_at: :desc)}

  accepts_nested_attributes_for :pictures, allow_destroy: true,
    reject_if: :all_blank

  def thumbnail
    pictures.find_by is_thumbnail: true
  end

  def must_have_one_thumbnail
    return if pictures.select(&:is_thumbnail).count == 1
    errors.add :thumbnail, t("shared.error_messages.must_have_one_thumbnail")
  end

  def active_trips
    trips.active
  end

  def lowest_price
    trips.minimum :price
  end

  def review_count
    reviews.count
  end
end
