class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def check_logged_in?
    return if logged_in?
    flash[:danger] = t "shared.error_messages.have_to_be_logged_in"
    store_location
    redirect_to login_url
  end
end
