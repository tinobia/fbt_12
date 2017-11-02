require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users :dan
  end

  test "login with invalid information" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: {session: {username: "", password: ""}}
    assert_template "sessions/new"
    assert_not flash.empty?
    assert_not is_logged_in?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: {session: {username: @user.username,
                                        password: "password"}}
    assert is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_template "static_pages/home"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_path
    # Simulate a user clicking logout in a second window.
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 1
    assert_select "a[href=?]", logout_path, count: 0
  end

  test "login with remembering" do
    log_in_as @user, remember_me: Settings.remember_me
    assert_equal cookies["remember_token"], assigns(:user).remember_token
  end

  test "login without remembering" do
    # Log in to set the cookie.
    log_in_as @user, remember_me: Settings.remember_me
    # Log in again and verify that the cookie is deleted.
    log_in_as @user, remember_me: Settings.forget_me
    assert_empty cookies["remember_token"]
  end
end
