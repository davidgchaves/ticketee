require 'spec_helper'

feature "Deleting Project" do
  let(:admin) { FactoryGirl.create :admin_user }

  context "Once an admin has logged in" do
    before do
      sign_in_as! admin
    end

    scenario "deleting a project succeeds" do
      FactoryGirl.create :project, name: "Vim 7.4"
      visit "/"
      click_link "Vim 7.4"
      click_link "Delete Project"

      expect(page).to have_content "Project has been destroyed."

      visit "/"

      expect(page).to have_no_content "Vim 7.4"
    end
  end
end
