require 'spec_helper'

feature "Assigning Permissions" do
  let!(:admin) { FactoryGirl.create :admin_user }
  let!(:user) { FactoryGirl.create :user }
  let!(:project) { FactoryGirl.create :project }

  context "Given an admin grants a user 'view' permissions to a project" do
    before do
      sign_in_as! admin
      click_link "Admin"
      click_link "Users"
      click_link user.email

      click_link "Permissions"
      check_permission_box "view", project

      click_button "Update"
      click_link "Sign out"
    end

    context "When the user signs in" do
      before { sign_in_as! user }

      scenario "Then she can view the project listed" do
        expect(page).to have_content project.name
      end
    end
  end
end
