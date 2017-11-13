class BookingRequestsController < ApplicationController
  before_action :valid_user
  before_action :load_trip, only: %i(new create)

  def new
    @booking_request = @trip.booking_requests.new user: @user
  end

  def create
    @booking_request = @trip.booking_requests.new \
      booking_request_params.merge(user: @user)
    @booking_request.stripe_token = params[:stripe_token]
    if @booking_request.save
      flash[:success] = t "shared.success_messages.booking_succeeded"
      redirect_to @booking_request.user
    else
      render :new
    end
  end

  private

  def load_trip
    return if (@trip = Trip.find_by id: params[:trip_id])
    flash[:danger] = t "shared.error_messages.trip_not_found", id: params[:trip_id]
    redirect_to root_url
  end

  def valid_user
    if logged_in?
      @user = User.find_by params[:user_id]
      return if current_user.is?(@user)
      flash[:danger] = t "shared.error_messages.not_allowed_to_view"
      redirect_to root_url
    else
      flash[:danger] = t "shared.error_messages.have_to_be_logged_in"
      store_location
      redirect_to login_url
    end
  end

  def booking_request_params
    params.require(:booking_request).permit :number_of_people
  end
end
