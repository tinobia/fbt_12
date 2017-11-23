module SessionHelper
  def expire_session_cookie!
    session = Capybara.current_session.driver.browser.current_session
    cookie_jar = session.instance_variable_get(:@rack_mock_session).cookie_jar
    cookies = cookie_jar.instance_variable_get(:@cookies)
    cookies.select!{|existing_cookie| existing_cookie.expired? == false}
  end
end
