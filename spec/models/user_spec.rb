require "rails_helper"

RSpec.describe User do
  subject(:user){FactoryBot.build :user}

  describe "Validations" do
    it{is_expected.to be_valid}

    context "with a email" do
      subject(:email_errors) do
        user.valid?
        user.errors[:email]
      end

      context "that is invalid" do
        before{user.email = "    "}
        it{is_expected.to include("can't be blank")}
      end

      context "that is duplicated" do
        before{@another_user = FactoryBot.create :user}
        it{is_expected.to include("has already been taken")}
      end
    end

    context "with a username" do
      subject(:username_errors) do
        user.valid?
        user.errors[:username]
      end

      context "that is empty" do
        before{user.username = "    "}
        it{is_expected.to include("can't be blank")}
      end

      context "that is too long" do
        before{user.username = "a" * 51}
        it{is_expected.to include("is too long (maximum is 50 characters)")}
      end

      context "that is too short" do
        before{user.username = "a" * 5}
        it{is_expected.to include("is too short (minimum is 6 characters)")}
      end

      context "that is duplicated" do
        before{@another_user = FactoryBot.create :user}
        it{is_expected.to include("has already been taken")}
      end
    end
  end

  it "save email as lower-case" do
    subject.email = "TesT@Abc.com"
    subject.save
    expect(subject.reload.email).to eq("test@abc.com")
  end
end
