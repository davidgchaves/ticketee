require 'spec_helper'

feature "Viewing Tickets" do
  before do
    vim_project = FactoryGirl.create :project, name: "Vim"
    FactoryGirl.create :ticket, project: vim_project, title: "Make it shiny!", description: "Gradients! Starbursts! Oh my!"

    emacs_project = FactoryGirl.create :project, name: "Emacs"
    FactoryGirl.create :ticket, project: emacs_project, title: "CTS" , description: "Carpal Tunnel Syndrome"

    visit '/'
  end

  scenario "Viewing tickets for a given project" do
    click_link "Vim"

    expect(page).to have_content "Make it shiny!"
    expect(page).to_not have_content "Carpal Tunnel Syndrome"

    click_link "Make it shiny!"
    within "#ticket h2" do
      expect(page).to have_content "Make it shiny!"
    end

    expect(page).to have_content "Gradients! Starbursts! Oh my!"
  end
end
