require "rails_helper"

RSpec.describe Admin::MainController do
  describe "GET index" do
    subject do
      get :index
    end
    context "when user is not signed in" do
      it{is_expected.to redirect_to(new_user_session_url)}
    end
    context "when user is signed in" do
      context "as a non admin user" do
        before do
          user = FactoryBot.create :user
          user.confirm
          sign_in user
        end
        it{is_expected.to redirect_to(root_url)}
      end
      context "as a admin user" do
        before do
          user = FactoryBot.create :user, is_admin: true
          user.confirm
          sign_in user
        end
        it{is_expected.to have_http_status 200}
      end
    end
  end

  context "with an admin user" do
    subject{FactoryBot.create :user, is_admin: true}
    it{is_expected.not_to redirect_to root_url}
  end
end
