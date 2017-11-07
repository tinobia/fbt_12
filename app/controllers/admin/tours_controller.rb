module Admin
  class ToursController < Admin::AdminController
    before_action :load_tour, except: %i(new index create)

    def new
      @tour = Tour.new
    end

    def index
      @tours = Tour.paginate page: params[:page],
        per_page: Settings.per_page.tour
    end

    def create
      @tour = Tour.new tour_params
      if @tour.save
        redirect_to admin_tours_url
      else
        render :new
      end
    end

    def show; end

    def edit; end

    def update
      if @tour.update_attributes tour_params
        flash[:success] = t "shared.success_messages.changes_saved"
        redirect_to admin_tour_url(@tour)
      else
        render :edit
      end
    end

    def destroy
      if @tour.destroy
        flash[:success] = t "shared.success_messages.tour_deleted"
      else
        flash[:danger] = t "shared.error_messages.can_not_delete_tour",
          id: params[:id]
      end
      redirect_to admin_tours_url
    end

    private

    def load_tour
      return if (@tour = Tour.find_by id: params[:id])
      flash[:danger] = t "shared.error_messages.tour_not_found", id: params[:id]
      redirect_to admin_root_url
    end

    def tour_params
      params.require(:tour).permit :name, :departure, :arrival,
        :itinerary, :overview
    end
  end
end