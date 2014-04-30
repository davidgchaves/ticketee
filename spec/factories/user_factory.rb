FactoryGirl.define do
  factory :user do
    name "my name"
    email "email@example.com"
    password "pwd"
    password_confirmation "pwd"

    factory :admin_user do
      admin true
    end
  end
end
