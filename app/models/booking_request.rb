class BookingRequest < ApplicationRecord
  attr_accessor :stripe_token

  belongs_to :user
  belongs_to :trip

  validates :number_of_people, presence: true, numericality: {greater_than: 0}
  validate :number_of_people_must_be_smaller_than_available_slot

  after_validation :process_payment
  after_save :update_total_people

  enum status: %i(pending paid)

  def total_price
    price * number_of_people
  end

  private

  def process_payment
    return if paid?
    customer = Stripe::Customer.create email: user.email,
      card: stripe_token
    update_attribute :price, trip.price
    Stripe::Charge.create customer: customer.id,
      amount: price * number_of_people * 100,
      description: trip.tour.name,
      currency: "usd"
    update_attribute :status, "paid"
  end

  def update_total_people
    return unless number_of_people_changed?
    Trip.update_counters trip.id,
      total_people: (number_of_people - (number_of_people_was || 0))
  end

  def number_of_people_must_be_smaller_than_available_slot
    return if number_of_people.nil? || number_of_people < trip.available_slot
    errors.add :number_of_people,
      t("shared.error_messages.must_be_smaller_than_available_slot")
  end
end
