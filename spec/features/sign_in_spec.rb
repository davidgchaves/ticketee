require 'spec_helper'

feature "Sign In" do
  let(:user) { FactoryGirl.create :user }

  before do
    visit '/'
    click_link "Sign in"
  end

  scenario "Sign in successfully using a form" do
    fill_in "Name", with: user.name
    fill_in "Password", with: user.password
    click_button "Sign in"

    expect(page).to have_content "Signed in successfully."
  end

  scenario "Trying to sign in with a wrong password" do
    fill_in "Name", with: user.name
    fill_in "Password", with: "bad pwd"
    click_button "Sign in"

    expect(page).to have_content "Sorry. Wrong username and/or password. Try again."
  end

  scenario "Trying to sign in with a wrong username" do
    fill_in "Name", with: "Wrong name"
    fill_in "Password", with: user.password
    click_button "Sign in"

    expect(page).to have_content "Sorry. Wrong username and/or password. Try again."
  end
end
