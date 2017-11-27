class ToursController < ApplicationController
  def index
    @q = Tour.ransack params[:q]
    @tours = @q.result(distinct: true).all.order_by_created_at
      .page(params[:page]).per Settings.per_page.tour
  end

  def show
    if (@tour = Tour.find_by id: params[:id])
      @trips = @tour.active_trips.order_by_created_at.page(params[:trip_page])
        .per Settings.per_page.trip
      @reviews = @tour.reviews.order_by_created_at.page(params[:review_page])
        .per Settings.per_page.review
    else
      flash[:danger] = t "shared.error_messages.tour_not_found",
        id: params[:id]
      redirect_to tours_url
    end
  end
end
