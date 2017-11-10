class Tour < ApplicationRecord
  attr_accessor :thumbnail_id

  belongs_to :category
  has_many :pictures, dependent: :destroy

  validates :avg_stars,
    numericality: {greater_than: 0, less_than_or_equal_to: 5},
    allow_nil: true
  validates :arrival, presence: true
  validates :departure, presence: true
  validates :itinerary, presence: true
  validates :overview, presence: true
  validate :valid_thumbnail

  after_validation :update_thumbnail

  scope :under_these_categories,
    ->(categories){where("category_id IN (#{categories})")}

  accepts_nested_attributes_for :pictures, allow_destroy: true,
    reject_if: :all_blank

  def thumbnail
    pictures.find_by is_thumbnail: true
  end

  def valid_thumbnail
    return if thumbnail_id.nil? || (@pic = pictures.find_by id: thumbnail_id)
    errors.add :thumbnail, t("shared.error_messages.is_not_valid")
  end

  def update_thumbnail
    return unless @pic && errors.empty?
    pictures.update is_thumbnail: false
    @pic.update_attributes is_thumbnail: true
  end
end
