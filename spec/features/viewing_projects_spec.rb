require 'spec_helper'

feature "Viewing Projects" do
  let!(:user) { FactoryGirl.create :user }
  let!(:project) { FactoryGirl.create :project }
  let!(:hidden_project) { FactoryGirl.create :project, name: "Hidden" }

  context "A signed in user" do
    before { sign_in_as! user }

    context "with permission to view a project" do
      before do
        define_permission! user, :view, project
        visit "/"
      end

      scenario "can list the project" do
        expect(page).to have_content project.name
      end

      scenario "can navigate to the project" do
        click_link project.name
        expect(page.current_url).to eq project_url(project)
      end
    end

    context "with no permission to view a project" do
      before { visit "/" }

      scenario "can't list the project" do
        expect(page).to_not have_content hidden_project.name
      end
    end
  end
end
