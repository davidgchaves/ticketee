require 'spec_helper'

feature "Signing up" do
  before do
    visit '/'
    click_link "Sign up"
    fill_in "Username", with: "David"
    fill_in "Email", with: "user@example.com"
  end

  scenario "Successful sign up" do
    fill_in "Password", with: "pwd"
    fill_in "Password confirmation", with: "pwd"
    click_button "Sign up"

    expect(page).to have_content "You have signed up successfully."
  end

  scenario "Unsuccessful sign up" do
    click_button "Sign up"

    expect(page).to have_content "Password can't be blank"
  end
end
