module Reviews
  class CommentsController < ::CommentsController
    before_action :set_commentable

    private

    def set_commentable
      return if (@commentable = Review.find_by id: params[:review_id])
      flash[:danger] = t "shared.error_messages.review_not_found", id: params[:review_id]
      redirect_to root_url
    end
  end
end
