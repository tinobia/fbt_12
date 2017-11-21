module Admin
  class ToursController < Admin::AdminController
    before_action :load_tour, except: %i(new index create)
    before_action :load_pictures, only: %i(edit update)
    before_action :load_categories, except: %i(index show destroy)

    def new
      @tour = Tour.new
    end

    def index
      @tours = Tour.order_by_created_at.page(params[:page])
        .per Settings.per_page.tour
    end

    def create
      @tour = Tour.new tour_params
      if @tour.save
        redirect_to admin_tours_url
      else
        render :new
      end
    end

    def show
      @trips = @tour.trips.order_by_created_at.page(params[:trip_page])
        .per Settings.per_page.trip
      @reviews = @tour.reviews.order_by_created_at.page(params[:review_page])
        .per Settings.per_page.review
    end

    def edit; end

    def update
      if @tour.update_attributes(tour_params)
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
      redirect_to admin_tours_url
    end

    def load_pictures
      @pictures =
        @tour.pictures.map{|pic| ["", pic.id, {"data-img-src": pic.image.url}]}
    end

    def load_categories
      @categories = Category.leaves
    end

    def tour_params
      params.require(:tour).permit :name, :departure, :arrival, :category_id,
        :itinerary, :overview, pictures_attributes: %i(id image is_thumbnail _destroy)
    end
  end
end
