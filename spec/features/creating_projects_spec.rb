require 'spec_helper'

feature "Creating Projects" do
  context "Once an admin has logged in" do
    let(:admin_user) { FactoryGirl.create :admin_user }
    before { sign_in_as! admin_user }

    context "Creating a project with valid data" do
      let(:project) { FactoryGirl.create :project }
      before do
        visit "/"
        click_link "New Project"
        fill_in "Name", with: project.name
        fill_in "Description", with: project.description
        click_button "Create Project"
      end

      scenario "succeeds" do
        expect(page).to have_content "Project has been created."
      end

      scenario "displays the right title for the newly created project" do
        expect(page).to have_title "#{project.name} - Projects - Ticketee"
      end
    end

    context "Creating a project without a name" do
      before do
        visit "/"
        click_link "New Project"
        click_button "Create Project"
      end

      scenario "fails" do
        expect(page).to have_content "Project has not been created."
      end

      scenario "displays the reason for failure" do
        expect(page).to have_content "Name can't be blank"
      end
    end
  end
end
