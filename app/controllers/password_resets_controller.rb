class PasswordResetsController < ApplicationController
  before_action :load_user, only: %i(create edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new; end

  def create
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "shared.info_messages.password_reset_email_sent"
      redirect_to root_url
    else
      flash.now[:danger] = t "shared.error_messages.email_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if user_params[:password].empty?
      handle_empty_password
    elsif @user.update_attributes user_params
      handle_reset_success
    else
      render :edit
    end
  end

  private

  def handle_empty_password
    @user.errors.add :password, t("shared.error_messages.can_not_be_empty")
    render :edit
  end

  def handle_reset_success
    log_in @user
    @user.update_attributes reset_digest: nil
    flash[:success] = t "shared.success_messages.password_has_been_reset"
    redirect_to root_url
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email].downcase
  end

  def valid_user
    redirect_to root_url unless @user&.activated? &&
      @user&.authenticated?(:reset, params[:id])
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t "shared.error_messages.reset_expired"
    redirect_to new_password_reset_url
  end
end
