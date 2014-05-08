require 'spec_helper'

feature "Editing Projects" do
  let(:admin) { FactoryGirl.create :admin_user }

  context "Once an admin has logged in" do
    before do
      sign_in_as! admin
      FactoryGirl.create :project, name: "Vim 7.4"

      visit "/"
      click_link "Vim 7.4"
      click_link "Edit Project"
    end

    scenario "updating a project succeeds" do
      fill_in "Name", with: "Vim 7.5 BETA"
      click_button "Update Project"

      expect(page).to have_content "Project has been updated."
    end

    scenario "updating a project without a name fails" do
      fill_in "Name", with: ""
      click_button "Update Project"

      expect(page).to have_content "Project has not been updated."
    end
  end
end
