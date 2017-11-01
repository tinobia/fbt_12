require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_select 'form[action="/signup"]'
    assert_no_difference "User.count" do
      post signup_path, params: {user: {username:  "",
                                        email: "user@invalid",
                                        password:              "foo",
                                        password_confirmation: "bar"}}
    end
    assert_template "users/new"
    assert_select "div#error_explanation"
    assert_select "div.field_with_errors"
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference "User.count", 1 do
      post signup_path, params: {user: {username: "test123",
                                        email:    "test@valid.com",
                                        password:              "test123",
                                        password_confirmation: "test123"}}
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns :user
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as user
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: "wrong")
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template "static_pages/home"
  end
end
