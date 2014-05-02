require 'spec_helper'

feature "Creating Users" do
  context "An admin user" do
    let(:admin) { FactoryGirl.create :admin_user }
    before do
      sign_in_as! admin

      visit "/"
      click_link "Admin"
      click_link "Users"
      click_link "New User"
    end

    scenario "can create a new user" do
      fill_in "Email", with: "newbie@example.com"
      fill_in "Password", with: "pwd"
      click_button "Create User"

      expect(page).to have_content "User has been created."
    end

    scenario "cannot create an invalid new user" do
      fill_in "Email", with: "newbie@example.com"
      click_button "Create User"

      expect(page).to have_content "User has not been created."
    end

    scenario "can create an admin user" do
      fill_in "Email", with: "admin@example.com"
      fill_in "Password", with: "pwd"
      check "Is an admin?"
      click_button "Create User"

      within "#users" do
        expect(page).to have_content "admin@example.com (Admin)"
      end
    end
  end
end
