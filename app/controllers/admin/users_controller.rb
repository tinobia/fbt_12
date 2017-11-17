module Admin
  class UsersController < Admin::AdminController
    before_action :load_user, only: %i(show edit update)

    def index
      @users = User.paginate page: params[:page],
        per_page: Settings.per_page.user
    end

    def show
      @requests = @user.booking_requests.paginate page: params[:page],
        per_page: Settings.per_page.booking_requests
      @reviews = @user.reviews.paginate page: params[:page],
        per_page: Settings.per_page.review
    end

    def edit; end

    def update
      if @user.update_attributes user_update_params
        flash[:success] = t "shared.success_messages.changes_saved"
        redirect_to admin_user_url(@user)
      else
        render :edit
      end
    end

    private

    def load_user
      return if (@user = User.find_by id: params[:id])
      flash[:danger] = t "shared.error_messages.user_not_found", id: params[:id]
      redirect_to admin_root_url
    end

    def user_update_params
      params.require(:user).permit :first_name, :last_name, :avatar
    end
  end
end
