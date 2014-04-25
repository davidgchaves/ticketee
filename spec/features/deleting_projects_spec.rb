require 'spec_helper'

feature 'Deleting Project' do
  scenario 'can delete a project' do
    FactoryGirl.create :project, name: 'Vim 7.4'
    visit '/'
    click_link 'Vim 7.4'
    click_link 'Delete Project'

    expect(page).to have_content 'Project has been destroyed.'

    visit '/'

    expect(page).to have_no_content 'Vim 7.4'
  end
end
