class BookingRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_trip, only: %i(new create)

  def new
    @booking_request = @trip.booking_requests.new user_id: params[:user_id]
  end

  def create
    @booking_request = @trip.booking_requests.new \
      booking_request_params.merge(user_id: params[:user_id])
    @booking_request.stripe_token = params[:stripe_token]
    if @booking_request.save
      flash[:success] = t "shared.success_messages.booking_succeeded"
      redirect_to @booking_request.user
    else
      render :new
    end
  rescue Stripe::CardError => e
    body = e.json_body
    err = body[:error]
    flash[:danger] = t "shared.error_messages.charge_declined",
      message: err[:message]
    render :new
  rescue Stripe::RateLimitError, Stripe::InvalidRequestError,
         Stripe::AuthenticationError, Stripe::APIConnectionError,
         Stripe::StripeError
    flash[:danger] = t "shared.error_messages.unexpected_error"
    render :new
  end

  private

  def load_trip
    return if (@trip = Trip.find_by id: params[:trip_id])
    flash[:danger] = t "shared.error_messages.trip_not_found", id: params[:trip_id]
    redirect_to root_url
  end

  def booking_request_params
    params.require(:booking_request).permit :number_of_people
  end
end
