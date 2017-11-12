module Admin
  class BookingRequestsController < AdminController
    before_action :load_request, only: %i(edit update destroy)
    before_action :load_users, except: %i(index destroy)
    before_action :load_trips, except: %i(destroy destroy)

    def index
      @requests = BookingRequest.all.paginate page: params[:page],
        per_page: Settings.per_page.booking_requests
    end

    def new
      @request = BookingRequest.new
    end

    def create
      @request = BookingRequest.new booking_request_params
      @request.paid!
      if @request.save
        flash[:success] = t "shared.success_messages.booking_request_created"
        redirect_to admin_booking_requests_url
      else
        render :new
      end
    end

    def edit; end

    def update
      if @request.update_attributes booking_request_params
        flash[:success] = t "shared.success_messages.changes_saved"
        redirect_to admin_booking_requests_url
      else
        render :new
      end
    end

    def destroy
      if @request.destroy
        flash[:success] = t "shared.success_messages.booking_request_deleted"
      else
        flash[:danger] = t "shared.error_messages.can_not_delete_booking_request",
          id: params[:id]
      end
      redirect_to admin_booking_requests_url
    end

    private

    def load_trips
      @trips = Trip.all
    end

    def load_users
      @users = User.all
    end

    def load_request
      return if (@request = BookingRequest.find_by id: params[:id])
      flash[:danger] = t "shared.error_messages.booking_request_not_found", id: params[:id]
      redirect_to admin_booking_requests_url
    end

    def booking_request_params
      params.require(:booking_request).permit :user_id, :trip_id,
        :number_of_people, :price
    end
  end
end
