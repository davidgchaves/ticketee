require 'spec_helper'

feature 'Creating Projects' do
  scenario 'can create a project' do
    visit '/'

    click_link 'New Project'

    fill_in 'Name', with: 'Vim 7.4'
    fill_in 'Description', with: 'My favorite text-editor'
    click_button 'Create Project'

    expect(page).to have_content 'Project has been created.'

    project = Project.where(name: 'Vim 7.4').first

    expect(page.current_url).to eql project_url(project)

    title = 'Vim 7.4 - Projects - Ticketee'
    expect(page).to have_title title
  end
end
