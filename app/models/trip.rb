class Trip < ApplicationRecord
  belongs_to :tour
  has_many :booking_requests, dependent: :destroy

  validates :from, presence: true
  validates :to, presence: true
  validates :max_people, presence: true,
    numericality: {greater_than: Settings.lowest_max_people,
                   less_than_or_equal_to: Settings.highest_max_people}
  validates :price, presence: true
  validate :total_people_smaller_than_or_equal_to_max_people
  validate :from_is_before_to

  scope :active, ->{where(active: true)}
  scope :order_by_created_at, ->{order(created_at: :desc)}

  delegate :name, to: :tour

  def available_slot
    max_people - total_people
  end

  private

  def total_people_smaller_than_or_equal_to_max_people
    return if total_people.nil? || total_people <= max_people
    errors.add :total_people,
      t("shared.error_messages.total_people_bigger_than_max_people")
  end

  def from_is_before_to
    return if from <= to
    errors.add :from,
      t("shared.error_messages.is_before_to")
  end
end
