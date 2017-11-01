class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      flash[:success] = t "shared.success_messages.account_activated"
    else
      flash[:danger] = t "shared.error_messages.invalid_activation_link"
    end
    redirect_to root_url
  end
end
