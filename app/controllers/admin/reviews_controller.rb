module Admin
  class ReviewsController < AdminController
    before_action :load_review, only: %i(show destroy)

    def show; end

    def destroy
      if @review.destroy
        flash[:success] = t "shared.success_messages.review_deleted"
      else
        flash[:danger] = t "shared.error_messages.can_not_delete_review",
          id: params[:id]
      end
      redirect_to admin_tour_url(@review.tour, tab: :reviews)
    end

    private

    def load_review
      return if (@review = Review.find_by id: params[:id])
      flash[:danger] = t "shared.error_messages.review_not_found", id: params[:id]
      redirect_to admin_tour_url(@review.tour, tab: :reviews)
    end
  end
end
