module Admin
  class AdminController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_user!

    layout "layouts/admin"

    private

    def authorize_user!
      return if current_user.is_admin?
      flash[:danger] = t "shared.error_messages.not_allowed_to_view"
      redirect_to root_url
    end
  end
end
