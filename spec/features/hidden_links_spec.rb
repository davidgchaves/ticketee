require 'spec_helper'

feature "Hidden Links" do
  let(:project) { FactoryGirl.create :project }

  context "Anonymous users" do
    scenario "cannot see the New Project link" do
      visit "/"
      expect(page).to_not have_link "New Project"
    end

    scenario "cannot see the Edit Project link" do
      visit project_path project
      expect(page).to_not have_link "Edit Project"
    end

    scenario "cannot see the Delete Project link" do
      visit project_path project
      expect(page).to_not have_link "Delete Project"
    end
  end

  context "Regular users" do
    let(:user) { FactoryGirl.create :user }
    before { sign_in_as! user }

    scenario "cannot see the New Project link" do
      visit "/"
      expect(page).to_not have_link "New Project"
    end

    scenario "cannot see the Edit Project link" do
      visit project_path project
      expect(page).to_not have_link "Edit Project"
    end

    scenario "cannot see the Delete Project link" do
      visit project_path project
      expect(page).to_not have_link "Delete Project"
    end
  end

  context "Admin users" do
    let(:admin_user) { FactoryGirl.create :admin_user }
    before { sign_in_as! admin_user }

    scenario "can see the New Project link" do
      visit "/"
      expect(page).to have_link "New Project"
    end

    scenario "can see the Edit Project link" do
      visit project_path project
      expect(page).to have_link "Edit Project"
    end

    scenario "can see the Delete Project link" do
      visit project_path project
      expect(page).to have_link "Delete Project"
    end
  end
end
