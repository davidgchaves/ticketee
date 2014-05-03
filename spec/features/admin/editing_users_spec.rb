require 'spec_helper'

feature "Editing Users" do
  let!(:admin) { FactoryGirl.create :admin_user }
  let!(:user) { FactoryGirl.create :user }

  before do
    sign_in_as! admin
    visit "/"
    click_link "Admin"
    click_link "Users"
    click_link user.email
    click_link "Edit User"
  end

  context "Updating a user with valid info" do
    before do
      fill_in "Email", with: "edited@example.com"
      click_button "Update User"
    end

    scenario "succeeds" do
      expect(page).to have_content "User has been updated."
    end

    scenario "displays the updated content" do
      within "#users" do
        expect(page).to have_content "edited@example.com"
      end
    end

    scenario "doesn't display the old content" do
      within "#users" do
        expect(page).to_not have_content user.email
      end
    end
  end

  context "Updating a user with invalid info" do
    before do
      fill_in "Email", with: ""
      click_button "Update User"
    end

    scenario "fails" do
      expect(page).to have_content "User has not been updated."
    end
  end

  context "Promoting a user to admin" do
    before do
      check "Is an admin?"
      click_button "Update User"
    end

    scenario "succeeds" do
      within "#users" do
        expect(page).to have_content "#{user.email} (Admin)"
      end
    end
  end
end
