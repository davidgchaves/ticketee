require 'spec_helper'

feature "Profile page" do
  let(:user) { FactoryGirl.create :user }

  scenario "viewing a user's profile" do
    visit user_path user

    expect(page).to have_content user.name
    expect(page).to have_content user.email
  end

  context "updating a user's profile" do
    before do
      visit user_path user
      click_link "Edit your profile"
    end

    scenario "with correct attributes" do
      fill_in "Username", with: "New-name"
      click_button "Update Profile"

      expect(page).to have_content "Your profile has been updated."
    end

    scenario "with incorrect attributes" do
      fill_in "Password", with: "wrong pwd"
      fill_in "Password", with: "right pwd"
      click_button "Update Profile"

      expect(page).to have_content "Password confirmation doesn't match Password"
    end
  end
end
