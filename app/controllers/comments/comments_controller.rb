module Comments
  class CommentsController < ::CommentsController
    before_action :set_commentable

    private

    def set_commentable
      return if (@commentable = Comment.find_by id: params[:comment_id])
      flash[:danger] = t "shared.error_messages.comment_not_found", id: params[:comment_id]
      redirect_to root_url
    end
  end
end
