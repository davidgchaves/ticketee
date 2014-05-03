require 'spec_helper'

feature "Deleting Users" do
  let!(:admin) { FactoryGirl.create :admin_user }
  let!(:user) { FactoryGirl.create :user }

  before do
    sign_in_as! admin
    visit "/"
    click_link "Admin"
    click_link "Users"
  end

  context "Deleting a user" do
    before do
      click_link user.email
      click_link "Delete User"
    end

    scenario "succeeds" do
      expect(page).to have_content "#{user.email} has been deleted."
    end
  end

  context "Deleting myself" do
    before do
      click_link admin.email
      click_link "Delete User"
    end

    scenario "fails" do
      expect(page).to have_content "You cannot delete yourself!"
    end
  end
end
