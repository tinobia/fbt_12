class UsersController < ApplicationController
  before_action :load_user, only: %i(update show)

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
    @user.update_attributes user_update_params
    flash[:success] = t "shared.success_messages.changes_saved"
    redirect_to @user
  end

  private

  def load_user
    return if (@user = User.find_by id: params[:id])
    flash[:danger] = t "shared.error_messages.user_not_found", id: params[:id]
    redirect_to root_url
  end

  def user_update_params
    params.require(:user).permit :first_name, :last_name, :avatar
  end

  def user_params
    params.require(:user).permit :username, :email,
      :password, :password_confirmation
  end
end
