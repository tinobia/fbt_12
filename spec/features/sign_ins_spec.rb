require "rails_helper"
require_relative "../helpers/session_helper"

RSpec.configure do |c|
  c.include SessionHelper
end

RSpec.feature "SignIns", type: :feature do
  before{@user = FactoryBot.create :user}
  it "signs me in with correct credentials" do
    visit new_user_session_url
    within("#new_user") do
      fill_in "Username", with: @user.username
      fill_in "Password", with: "password"
    end
    click_button "Login"
    expect(page).to have_content "Signed in successfully."
  end

  it "doesn't sign me in with incorrect credentials" do
    visit new_user_session_url
    within("#new_user") do
      fill_in "Username", with: @user.username
      fill_in "Password", with: "wrong password"
    end
    click_button "Login"
    expect(page).to have_no_content "Signed in successfully."
  end

  context "when logged in with remember me" do
    before do
      visit new_user_session_url
      within("#new_user") do
        fill_in "Username", with: @user.username
        fill_in "Password", with: "password"
        check "Remember me next time"
      end
      click_button "Login"
    end
    it "still remember user when browser session expired" do
      expire_session_cookie!
      visit root_url
      expect(page).to have_no_selector "a[href='#{new_user_session_url}']"
    end
  end
end
