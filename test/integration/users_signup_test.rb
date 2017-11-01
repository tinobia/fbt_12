require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
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
    follow_redirect!
    assert_not flash.empty?
    assert_template "static_pages/home"
  end
end
