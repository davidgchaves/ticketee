require 'spec_helper'

feature "Viewing Projects" do
  let!(:user) { FactoryGirl.create :user }
  let!(:project) { FactoryGirl.create :project }

  context "A signed in user" do
    before do
      sign_in_as! user
      define_permission! user, :view, project
    end

    scenario "can list all projects" do
      visit "/"
      click_link project.name

      expect(page.current_url).to eq project_url(project)
    end
  end
end
