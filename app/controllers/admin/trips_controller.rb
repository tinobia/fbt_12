module Admin
  class TripsController < AdminController
    before_action :load_tour, only: %i(new create)
    before_action :load_trip, except: %i(new create)

    def new
      @trip = @tour.trips.new
    end

    def create
      @trip = @tour.trips.new trip_params
      if @trip.save
        redirect_to admin_tour_path(@trip.tour, tab: :trips),
          success: t("shared.success_messages.trip_created")
      else
        render :new
      end
    end

    def show
      @requests = @trip.booking_requests.paginate page: params[:page],
        per_page: Settings.per_page.booking_requests
    end

    def edit; end

    def update
      if @trip.update_attributes trip_params
        flash[:success] = t "shared.success_messages.changes_saved"
        redirect_to admin_tour_url(@trip.tour, tab: Settings.trips_tab)
      else
        render :edit
      end
    end

    def destroy
      if @trip.destroy
        flash[:success] = t "shared.success_messages.trip_deleted"
      else
        flash[:danger] = t "shared.error_messages.can_not_delete_trip",
          id: params[:id]
      end
      redirect_to admin_tour_url(@trip.tour, tab: Settings.trips_tab)
    end

    private

    def load_tour
      return if (@tour = Tour.find_by id: params[:tour_id])
      flash[:danger] = t "shared.error_messages.tour_not_found", id: params[:tour_id]
      redirect_to admin_tours_url
    end

    def load_trip
      return if (@trip = Trip.find_by id: params[:id])
      flash[:danger] = t "shared.error_messages.trip_not_found", id: params[:id]
      redirect_to admin_tours_url
    end

    def trip_params
      params.require(:trip).permit :from, :to, :max_people, :price,
        :active, :tour_id
    end
  end
end
