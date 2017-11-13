class ReviewsController < ApplicationController
  before_action :load_review, only: %i(update destroy)
  before_action :load_tour, only: :create
  before_action :check_logged_in?
  before_action :authorize_user!, only: :update

  def create
    @review = @tour.reviews.new review_params.merge(user_id: params[:user_id])
    @review.save
  end

  def update
    @review.update_attributes review_params
  end

  def destroy
    return if @review.destroy
    @error =
      t "shared.error_messages.can_not_delete_review", params[:id]
  end

  private

  def authorize_user!
    @user = @review&.user || User.find_by(params[:user_id])
    return if current_user.is?(@user)
    flash[:danger] = t "shared.error_messages.not_allowed"
    redirect_to root_url
  end

  def load_review
    return if (@review = Review.find_by id: params[:id])
    flash[:danger] = t "shared.error_messages.review_not_found", id: params[:id]
    redirect_to root_url
  end

  def load_tour
    return if (@tour = Tour.find_by id: params[:tour_id])
    flash[:danger] = t "shared.error_messages.tour_not_found", id: params[:tour_id]
    redirect_to root_url
  end

  def review_params
    params.require(:review).permit :content, :stars
  end
end
