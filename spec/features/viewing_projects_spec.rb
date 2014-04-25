require 'spec_helper'

feature 'Viewing Projects' do
  scenario 'can list all projects' do
    vim_project = FactoryGirl.create :project, name: 'Vim 7.4'
    visit '/'
    click_link 'Vim 7.4'

    expect(page.current_url).to eql project_url(vim_project)
  end
end
