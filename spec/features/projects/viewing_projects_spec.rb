require 'spec_helper'

feature "Viewing Projects" do
  let!(:user) { FactoryGirl.create :user }
  let!(:project) { FactoryGirl.create :project }
  let!(:hidden_project) { FactoryGirl.create :project, name: "Hidden" }

  context "Given a signed in user with 'view project' permission" do
    before do
      sign_in_as! user
      define_permission! user, "view project", project
    end

    scenario "Then she can list the project" do
      visit "/"
      expect(page).to have_content project.name
    end

    scenario "Then she can navigate to the project" do
      visit "/"
      click_link project.name
      expect(page.current_url).to eq project_url(project)
    end
  end

  context "Given a signed in user with no 'view project' permission" do
    before { sign_in_as! user }

    scenario "can't list the project" do
      visit "/"
      expect(page).to_not have_content hidden_project.name
    end
  end
end
