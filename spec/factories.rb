FactoryBot.define do
  factory :user do
    username "tanhuynh"
    email "test@abc.com"
    first_name "Tan"
    last_name "Huynh"
    password "password"
    password_confirmation "password"

    after :create, &:confirm
  end
end
