require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get root_url
    assert_template "static_pages/home"
    assert_response :success
  end

  test "should get about" do
    get about_url
    assert_template "static_pages/about"
    assert_response :success
  end

  test "should get contact" do
    get contact_url
    assert_template "static_pages/contact"
    assert_response :success
  end
end
