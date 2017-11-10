class SessionsController < ApplicationController
  before_action :load_user, only: :create

  def new; end

  def create
    if @user && @user.authenticate(session_params[:password])
      if @user.activated?
        handle_login
      else
        handle_account_not_activated
      end
    else
      handle_invalid_login
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def handle_login
    log_in @user
    should_remember = session_params[:remember_me] == Settings.remember_me
    should_remember ? remember(@user) : forget(@user)
    redirect_back_or @user
  end

  def handle_account_not_activated
    message = t "shared.warning_messages.account_not_activated"
    flash[:warning] = message
    redirect_to root_url
  end

  def handle_invalid_login
    flash[:danger] =
      t "shared.error_messages.invalid_login_credential"
    redirect_to root_url
  end

  def load_user
    @user = User.find_by username: session_params[:username]
  end

  def session_params
    params.require(:session).permit :username, :password, :remember_me
  end
end
