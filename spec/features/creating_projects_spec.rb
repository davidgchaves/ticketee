require 'spec_helper'

feature "Creating Projects" do
  let(:admin_user) { FactoryGirl.create :admin_user }

  before do
    sign_in_as! admin_user
    visit "/"
    click_link "New Project"
  end

  scenario "Creating a project" do
    fill_in "Name", with: "Vim 7.4"
    fill_in "Description", with: "My favorite text-editor"
    click_button "Create Project"

    expect(page).to have_content "Project has been created."

    project = Project.where(name: "Vim 7.4").first

    expect(page.current_url).to eq project_url(project)

    title = "Vim 7.4 - Projects - Ticketee"
    expect(page).to have_title title
  end

  scenario "can not create a project without a name" do
    click_button "Create Project"

    expect(page).to have_content "Project has not been created."
    expect(page).to have_content "Name can't be blank"
  end
end
