require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"

module ActiveSupport
  class TestCase
    include ApplicationHelper
    include AbstractController::Translation
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Returns true if a test user is logged in.
    def is_logged_in?
      session[:user_id].present?
    end

    # Log in as a particular user.
    def log_in_as user
      session[:user_id] = user.id
    end
  end
end

module ActionDispatch
  class IntegrationTest
    # Log in as a particular user.
    def log_in_as user, password: "password", remember_me: Settings.remember_me
      post login_path, params: {session: {username: user.username,
                                          password: password,
                                          remember_me: remember_me}}
    end
  end
end
