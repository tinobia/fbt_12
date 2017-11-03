require "test_helper"

module Admin
  class AdminControllerTest < ActionDispatch::IntegrationTest
    def setup
      @user = users :jonny
      @admin = users :dan
    end

    test "have to be logged in to view admin" do
      get admin_root_url
      assert_redirected_to login_url
    end

    test "user have to be admin" do
      log_in_as @user
      get admin_root_url
      assert_redirected_to root_url
      follow_redirect!
      assert_not flash.empty?
    end

    # rubocop:disable AmbiguousRegexpLiteral
    test "admin can view admin page" do
      log_in_as @admin
      get admin_root_url
      assert_match /Admin/i, response.body
    end
  end
end
