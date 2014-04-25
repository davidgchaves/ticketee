require 'spec_helper'

feature 'Editing Projects' do
  before do
    FactoryGirl.create :project, name: 'Vim 7.4'

    visit '/'
    click_link 'Vim 7.4'
    click_link 'Edit Project'
  end

  scenario 'can update a project' do
    fill_in 'Name', with: 'Vim 7.5 BETA'
    click_button 'Update Project'

    expect(page).to have_content "Project has been updated."
  end

  scenario 'can not update a project without a name' do
    fill_in 'Name', with: ''
    click_button 'Update Project'

    expect(page).to have_content "Project has not been updated."
  end
end
