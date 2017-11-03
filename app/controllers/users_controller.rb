class UsersController < ApplicationController
  before_action :load_user, only: %i(update show)
  before_action :valid_user, only: %i(update show)

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "shared.info_messages.check_email_notice"
      redirect_to root_url
    else
      render :new
    end
  end

  def show; end

  def update
    if @user.update_attributes user_update_params
      flash[:success] = t "shared.success_messages.changes_saved"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def load_user
    return if (@user = User.find_by id: params[:id])
    flash[:danger] = t "shared.error_messages.user_not_found", id: params[:id]
    redirect_to root_url
  end

  def valid_user
    if logged_in?
      return if current_user.is?(@user) || current_user.is_admin?
      flash[:danger] = t "shared.error_messages.not_allowed_to_view"
      redirect_to root_url
    else
      flash[:danger] = t "shared.error_messages.have_to_be_logged_in"
      store_location
      redirect_to login_url
    end
  end

  def user_update_params
    params.require(:user).permit :first_name, :last_name, :avatar
  end

  def user_params
    params.require(:user).permit :username, :email,
      :password, :password_confirmation
  end
end
