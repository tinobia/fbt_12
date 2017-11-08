class Tour < ApplicationRecord
  attr_accessor :thumbnail_id

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

  accepts_nested_attributes_for :pictures, allow_destroy: true,
    reject_if: :all_blank

  def thumbnail
    pictures.find_by is_thumbnail: true
  end

  def valid_thumbnail
    return if (@pic = pictures.find_by id: thumbnail_id)
    errors.add :thumbnail, t("shared.error_messages.is_not_valid")
  end

  def update_thumbnail
    return unless errors.empty?
    pictures.update is_thumbnail: false
    @pic.update_attributes is_thumbnail: true
  end
end
