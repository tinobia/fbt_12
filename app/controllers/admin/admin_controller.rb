module Admin
  class AdminController < ApplicationController
    before_action :authorize_user

    layout "layouts/admin"

    private

    def authorize_user
      if logged_in?
        return if current_user.is_admin?
        flash[:danger] = t "shared.error_messages.not_allowed_to_view"
        redirect_to root_url
      else
        flash[:danger] = t "shared.error_messages.have_to_be_logged_in"
        store_location
        redirect_to login_url
      end
    end
  end
end
